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
        
        print(f"Checking {len(puzzles)} puzzles...")
        
        # Performance optimization: Fetch all existing documents once
        # Note: If the collection is huge, this might need pagination or individual checks
        existing_docs = collection_ref.stream()
        existing_data = {doc.id: doc.to_dict() for doc in existing_docs}
        
        uploaded_count = 0
        skipped_count = 0
        
        for puzzle in puzzles:
            doc_id = str(puzzle.get('id'))
            
            # Check if puzzle already exists and is identical
            if doc_id in existing_data and existing_data[doc_id] == puzzle:
                skipped_count += 1
                continue
            
            # Use the 'id' from the JSON as the Document ID for clean organization
            # .set() performs an 'upsert' (creates if missing, overwrites if exists)
            collection_ref.document(doc_id).set(puzzle)
            print(f"Uploaded/Updated: Puzzle ID {doc_id}")
            uploaded_count += 1
            
        print(f"\nSummary:")
        print(f"- Successfully uploaded/updated {uploaded_count} puzzles.")
        print(f"- Skipped {skipped_count} identical puzzles.")
        print("Success: Firestore is in sync with puzzles.json.")
        
    except FileNotFoundError:
        print(f"Error: Could not find the file at {json_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    upload_puzzles()
