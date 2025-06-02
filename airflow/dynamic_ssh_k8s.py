from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.ssh.operators.ssh import SSHOperator
from datetime import datetime, timedelta
import json

default_args = {
    'owner': 'airflow',
}

with DAG(
    dag_id="dynamic_ssh_k8s",
    default_args=default_args,
    schedule=None,
    start_date=datetime.now() - timedelta(days=1),
    catchup=False,
) as dag:

    get_ips = BashOperator(
        task_id="get_ips",
        bash_command="terraform output -json",
        cwd="/home/achref/azure_terraform",
        do_xcom_push=True,
    )

    def extract_ip_from_output(**context):
        outputs = json.loads(context['ti'].xcom_pull(task_ids='get_ips'))
        return outputs["control_plane_public_ip"]["value"], outputs["worker_public_ip"]["value"]

    def update_ssh_hosts(**context):
        control_ip, worker_ip = extract_ip_from_output(**context)

        # Update SSHOperator dynamically
        context["ti"].xcom_push(key="control_ip", value=control_ip)
        context["ti"].xcom_push(key="worker_ip", value=worker_ip)

    prepare = PythonOperator(
        task_id="prepare_ssh",
        python_callable=update_ssh_hosts,
    )

    def make_ssh_task(task_id, ip_key, command):
        return SSHOperator(
            task_id=task_id,
            command=command,
            ssh_conn_id=None,
            ssh_hook={
                "conn_type": "SSH",
                "remote_host": "{{ ti.xcom_pull(key='" + ip_key + "') }}",
                "username": "azureuser",  # replace this with your actual username
                "key_file": "/home/airflow/.ssh/id_rsa",
            },
        )

    control_plane_ssh = make_ssh_task("control_plane_ssh", "control_ip", "hostname")
    worker_ssh = make_ssh_task("worker_ssh", "worker_ip", "hostname")

    get_ips >> prepare >> [control_plane_ssh, worker_ssh]
