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
