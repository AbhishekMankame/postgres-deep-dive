## POSTGRES Sandbox Cheatsheet (Codespaces)

### 1.Connect to the database
<pre>psql -h localhost -p 5433 -U codespace -d postgres_sandbox</pre>

- -h localhost -> host
- -p 5433 -> mapped container port
- -U codespace -> username
- -d postgres_sandbox -> database name
- Password: codespace

### 2.Exit psql
<pre>\q</pre>

- Quit Postgres prompt

### 3. Turn off pager
<pre>\pset pager off</pre>

- Prevent (END) screens for long outputs

### 4.List databases
<pre>\l</pre>

- Shows all databases in the container

### 5.List tables
<pre>\dt</pre>

- Shows all tables in the current database