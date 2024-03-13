# script for insert data in itCompany database using Python
from pymongo import MongoClient
from datetime import datetime
from bson.json_util import dumps
import json

# Connect to MongoDB
client = MongoClient('mongodb://localhost:27017/') # basic localhost, dont change if u are newbie
db = client['itCompany']  # Replace 'your_database' with your actual database name

def select_collection():
    print("Select the collection:")
    collections = ['department', 'employee', 'childrens']
    for i, collection in enumerate(collections, start=1):
        print(f"{i}. {collection}")
    print("0. Exit")
    choice = int(input("Enter your choice: "))
    if choice == 0:
        return None
    return collections[choice - 1]

def insert_document(collection):
    if collection == 'department':
        data = {
            "id_department": int(input("Enter department ID: ")),
            "depart_name": input("Enter department name: ")
        }
    elif collection == 'employee':
        data = {
            "id_emp": int(input("Enter employee ID: ")),
            "id_department": int(input("Enter department ID: ")),
            "name_emp": input("Enter employee name: "),
            "surname_emp": input("Enter employee surname: "),
            "adress_emp": input("Enter employee address: "),
            "gender_emp": input("Enter employee gender (M/F): "),
            "date_birth_emp": datetime.strptime(input("Enter date of birth (YYYY-MM-DDTHH:MM:SSZ): "), "%Y-%m-%dT%H:%M:%SZ"),
            "idnp_emp": input("Enter employee IDNP: "),
            "position": input("Enter employee position: "),
            "hiredate_emp": datetime.strptime(input("Enter hire date (YYYY-MM-DDTHH:MM:SSZ): "), "%Y-%m-%dT%H:%M:%SZ"),
            "hours_worked": int(input("Enter hours worked: ")),
            "hourly_rate": float(input("Enter hourly rate: ")),
            "total_salary": float(input("Enter total salary: ")),
            "num_childrens": int(input("Enter number of children: "))
        }
    elif collection == 'childrens':
        data = {
            "id_child": int(input("Enter child ID: ")),
            "id_emp": int(input("Enter employee ID: ")),
            "child_name": input("Enter child name: "),
            "child_surname": input("Enter child surname: ")
        }
    else:
        print("Invalid collection!")
        return

    db[collection].insert_one(data)
    print("Document inserted successfully!")

def show_collection_data(collection):
    print(f"\nData from collection '{collection}':")
    for document in db[collection].find():
        print(dumps(document, indent=4))
    print()

def update_document(collection):
    # Implement update logic here
    pass

# Function to export selected collection to JSON
# Function to export selected collection to JSON
# Function to export selected collection to JSON
from bson import json_util

# Function to export selected collection to JSON
def export_collection_to_json(collection_name, filename):
    data = []
    for document in db[collection_name].find():
        # Convert datetime objects to string format
        for key, value in document.items():
            if isinstance(value, datetime):
                document[key] = value.strftime("%Y-%m-%d %H:%M:%S")
        data.append(document)
    
    with open(filename, 'w') as file:
        json.dump(data, file, indent=4, default=json_util.default)

# Add this function to your main menu
def export_collection(collection):
    filename = input("Enter the filename to save the exported collection (without extension): ")
    export_collection_to_json(collection, filename + '.json')
    print(f"Collection '{collection}' exported to JSON successfully!")

def delete_document(collection):
    # Implement delete logic here
    pass

def main():
    while True:
        collection = select_collection()
        if not collection:
            break
        while True:
            print(f"\nSelected collection: {collection}")
            print("Choose an action:")
            print("1. Insert")
            print("2. Update")
            print("3. Delete")
            print("4. Show collection data")
            print("5. Export collections to JSON")
            print("0. Go back")
            action = int(input("Enter your choice: "))
            if action == 0:
                break
            elif action == 1:
                insert_document(collection)
            elif action == 2:
                update_document(collection)
            elif action == 3:
                delete_document(collection)
            elif action == 4:
                show_collection_data(collection)
            elif action == 5:
                export_collection(collection)
            else:
                print("Invalid choice!")

if __name__ == "__main__":
    main()
