from airflow import DAG
from airflow.operators.bash import BashOperator
import pendulum

default_args = {
    'owner': 'achref',
    'start_date': pendulum.yesterday("UTC"),
    'retries': 1,
}

with DAG(
    dag_id='terraform_k8s_deploy',
    default_args=default_args,
    description='Deploy Azure Kubernetes infrastructure using Terraform',
    schedule=None,
    catchup=False,
) as dag:

    terraform_dir = "/home/achref/azure_terraform"

    init_terraform = BashOperator(
        task_id='init_terraform',
        bash_command=f'cd {terraform_dir} && terraform init',
    )

    plan_terraform = BashOperator(
        task_id='plan_terraform',
        bash_command=f'cd {terraform_dir} && terraform plan -out=tfplan',
    )

    apply_terraform = BashOperator(
        task_id='apply_terraform',
        bash_command=f'cd {terraform_dir} && terraform apply -auto-approve tfplan',
    )

    # Optional destroy step if needed
    destroy_terraform = BashOperator(
        task_id='destroy_terraform',
        bash_command=f'cd {terraform_dir} && terraform destroy -auto-approve',
        trigger_rule='all_done',
    )

    # DAG workflow: only up to apply step by default
    init_terraform >> plan_terraform >> apply_terraform
