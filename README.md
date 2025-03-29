# Credit Note Management System

## Project Overview
This project allows users to create, store, and manage credit notes for invoices. The system provides a user-friendly UI to enter, update, and delete credit notes while ensuring data integrity through proper validations. 

## Features
- Create a credit note by entering required details.
- Fetch customers from the database.
- Validate invoice number based on selected customer.
- Enter and validate credit note details (date, description, amount, etc.).
- Select a status for the credit note (Pending, Approved, Rejected).
- Store credit notes securely in the database.
- View a list of all created credit notes.
- Edit or delete an existing credit note.

## Technologies Used
- **Frontend**: Flutter
- **Backend**: FastAPI (Python)
- **Database**: PostgreSQL

## Installation and Setup
### Prerequisites
Ensure you have the following installed:
- Flutter SDK
- Python & FastAPI
- PostgreSQL

### Steps to Run the Project
#### Backend (FastAPI)
1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/credit-note-management.git
   cd credit-note-management/backend
   ```
2. **Create and activate a virtual environment:**
   ```sh
   python -m venv venv
   source venv/bin/activate  # For macOS/Linux
   venv\Scripts\activate  # For Windows
   ```
3. **Install dependencies:**
   ```sh
   pip install -r requirements.txt
   ```
4. **Setup database:**
   - Configure PostgreSQL connection in `.env` or `config.py`.
   - Apply migrations if necessary.
5. **Run the FastAPI server:**
   ```sh
   uvicorn main:app --reload
   ```
6. **Access API Docs:**
   Open `http://127.0.0.1:8000/docs` in your browser.

#### Frontend (Flutter)
1. **Navigate to the Flutter app directory:**
   ```sh
   cd ../frontend
   ```
2. **Install Flutter dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the Flutter app:**
   ```sh
   flutter run
   ```

## Validations
- **Invoice Number**: Required and must be valid.
- **Date of Credit Note**: Required and must be a valid date.
- **Description**: Required.
- **Amount**: Required and must be a positive number.
- **Reason**: Optional.

## API Endpoints
| Method | Endpoint | Description |
|--------|----------|--------------|
| GET | `/credit-notes` | Fetch all credit notes |
| POST | `/credit-notes` | Create a new credit note |
| PUT | `/credit-notes/{id}` | Update an existing credit note |
| DELETE | `/credit-notes/{id}` | Delete a credit note |

## Contribution
1. Fork the repository.
2. Create a new branch (`feature-branch`).
3. Commit your changes.
4. Push to the branch and create a pull request.

## License
This project is licensed under the MIT License.

## Contact
For queries or contributions, reach out to [Mahanandha J] at [mahanandhan2002@gmail.com].

