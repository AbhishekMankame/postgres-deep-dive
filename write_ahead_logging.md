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