import random

def generate_random_numbers(num_of_random_numbers):
  random_numbers = []
  for i in range(num_of_random_numbers):
    random_numbers.append("{:04d}".format(random.randint(0,9999)))
  return random_numbers

first_prize = generate_random_numbers(1)
second_prize = generate_random_numbers(1)
third_prize = generate_random_numbers(1)
special_prize = generate_random_numbers(10)
consolation_prize = generate_random_numbers(10)

print("First Prize:", first_prize[0])
print("Second Prize:", second_prize[0])
print("Third Prize:", third_prize[0])
print("Special Prize:", special_prize)
print("Consolation Prize:", consolation_prize)

---------------------------------------
import subprocess

def get_user_input(prompt, default_value=None):
    user_input = input(f"{prompt} [{default_value}]: ")
    return user_input if user_input.strip() else default_value

def pull_from_nexus(event, context):
    # Get user input for Nexus details
    nexus_repository_url = get_user_input("Enter Nexus Repository URL")
    nexus_image_name = get_user_input("Enter Nexus Image Name")

    # Authenticate with Nexus (if needed)
    subprocess.run(["docker", "login", nexus_repository_url])

    # Pull the image from Nexus
    subprocess.run(["docker", "pull", f"{nexus_repository_url}/{nexus_image_name}"])

    return {
        'statusCode': 200,
        'body': 'Image pulled from Nexus successfully!'
    }
---------------------------------------------
push-image
import subprocess

def get_user_input(prompt, default_value=None):
    user_input = input(f"{prompt} [{default_value}]: ")
    return user_input if user_input.strip() else default_value

def push_to_ecr(event, context):
    # Get user input for ECR details
    ecr_repository_uri = get_user_input("Enter ECR Repository URI")

    # Authenticate with ECR
    ecr_login_command = f"docker login -u AWS {ecr_repository_uri}"
    subprocess.run(ecr_login_command, shell=True)

    # Tag the image for ECR
    subprocess.run(["docker", "tag", f"{nexus_repository_url}/{nexus_image_name}", ecr_repository_uri])

    # Push the image to ECR
    subprocess.run(["docker", "push", ecr_repository_uri])

    return {
        'statusCode': 200,
        'body': 'Image pushed to ECR successfully!'
    }
