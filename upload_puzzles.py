import firebase_admin
from firebase_admin import credentials, firestore
import json
import os

# 1. Initialize Firebase Admin
# Ensure serviceAccountKey.json is in the same directory as this script
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def upload_puzzles():
    # 2. Path to your JSON file
    json_path = os.path.join('assets', 'data', 'puzzles.json')
    
    try:
        with open(json_path, 'r') as f:
            puzzles = json.load(f)
            
        # 3. Reference the 'puzzles' collection
        collection_ref = db.collection('puzzles')
        
        print(f"Starting upload of {len(puzzles)} puzzles...")
        
        for puzzle in puzzles:
            # Use the 'id' from the JSON as the Document ID for clean organization
            doc_id = str(puzzle.get('id'))
            collection_ref.document(doc_id).set(puzzle)
            print(f"Uploaded: Puzzle ID {doc_id}")
            
        print("\nSuccess: All puzzles have been added to Firestore.")
        
    except FileNotFoundError:
        print(f"Error: Could not find the file at {json_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    upload_puzzles()