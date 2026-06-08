# Oracle DB Docker
---
Docker image for Oracle DB

## Getting Started
### Prerequisites
- Docker
- Oracle 11g XE package - [Download](https://drive.google.com/drive/folders/1Pm5VusW2jD-FGD4XduHOj6fU7BnDgbT6?usp=sharing)

### Installation
1. Clone this repository:
   ``` bash
   git clone https://github.com/dawnj26/oracle-11g-docker
   ```
2. Navigate to the repository directory:
   ``` bash
   cd oracle-11g-docker
   ```
3. Place the Oracle 11g XE package in the `/assets` directory.
4. Build the Docker image:
   ``` bash
   docker compose up --build
   ```
5. Enter the container:
   ``` bash
   docker exec -it oracle-11g-xe bash
   ```
6. Create user and password for Oracle DB using `create_user` script and enter username and password:
   ``` bash
   create_user
   Enter Oracle username: <username>
   Enter password: <password>
   ```
7. Import latest dump usually named `<username><random_number>.dmp`:
   ``` bash
   impdp system/oracle DIRECTORY=DUMP_DIR DUMPFILE=<filename>.dmp REMAP_SCHEMA=<dmp_username>:<username> LOGFILE=import.log
   ```

### Usage
- To run the container:
   ``` bash
   docker compose up -d
   ```
- To stop the container:
   ``` bash
   docker compose down
   ```
- To change SYS/SYSTEM password:

  1. Enter the container:
   ``` bash
   docker exec -it oracle-11g-xe bash
   ```
  2. Set the new password:
   ``` bash
   set_password <new_password>
   ```
