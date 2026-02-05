## Write Ahead Logging (WAL)

### 1. Why WAL exists (the problem)
Modern systems store data on disk, but disk writes are:
- Slow
- Can fail mid-write<br>
If a system updates data in place and crashes halfway, the data becomes corrupted. We need a way to guarantee durability and consistency even if the system crashes at the worst possible moment.<br>
This is the exact problem WAL solves.<br>
Write-Ahead Logging (WAL) is a technique used in storage systems to ensure durability and consistency in the presence of crashes. Since disk writes are slow and non-atomic, directly updating data structures can lead to corruption if a crash occurs mid-write. WAL solves this by recording all intended changes in a persistent log before applying them to the actual data.

### 2. Core idea of WAL (intution)
Golden Rule of WAL: "Never modify data on disk before logging the change."<br>
Instead of updating data directly:
1. Append the change to a log
2. Flush the log to disk
3. Only then apply the change to the database<br>
Why this works:
- Appending to a log is fast
- Log writes are sequential
- During recovery, the log becomes the source of truth<br>
Think of WAL as a block box flight recorder for your database.<br>
The core idea of Write-Ahead Logging is that all changes are first written to a sequential log on persistent storage before being applied to the actual database. This guarantees that even if the system crashes, the log contains enough information to reconstruct or undo operations, making recovery possible.

### 3. How WAL works (step-by-step)
Let's say a transaction wants to update:
<pre>
Account A: 100 -> 50
Account B: 200 -> 250
</pre>
Steps:
1. Create a log record describing the change
- Old value (optional)
- New value
- Transaction ID
2. Append log record to WAL
3. Flush WAL to disk (fsync)
4. Apply changes to in-memory data pages
5. Eventual flush data pages to disk<br>
Important: Data pages can be written later. WAL must be written first.<br>
When a transaction modifies data, the system first creates a log record describing the change. This log record is appended to the write-ahead log and flush to disk. Only after the log is safely persisted are the changes applied to the in-memory database pages. The actual data pages may be written to disk later, but the presence of the log ensures the changes are not lost.

### 4. Crash recovery using WAL
Now imagine a crash happens.<br>
Case 1: Log written, data not written --> Safe - replay the log (REDO) ✅ <br>
Case 2: Transaction is ignored (as if it never happened) ❌ <br>
Recovery process:
1. Scan WAL from last checkpoint.
2. For each committed transaction -> REDO
3. For uncommitted transactions -> UNDO (if needed)<br>
This gives atomicity and durability.<br>
During crash recovery, the system scans the write-ahead log to determined which transactions were committed before the crash. Changes from committed transactions are reapplied using REDO, while uncommitted transactions are ignored or rolled back. This allow the system to restore a consistent state without data corruption.