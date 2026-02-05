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

### 5. WAL + Transactions (commit protocol)
A transaction is considered committed only when:
- Its commit record is written and flushed to WAL<br>
Even if data pages are not yet written, the transaction is durable.<br>
This is why WAL is tightly coupled with:
- ACID properties
- Two-phase commit (in distributed systems)
- Database commits<br>
In system using WAL, a transaction is considered committed only after its commit record has been flushed to the write-ahead log. This ensures durability, since the transaction can always be recovered from the log even if the actual data pages have not yet been written to disk.

### 6. WAL in distributed systems
In distributed systems, WAL is used in:
- Databases (Postgres, MySQL, Spanner)
- Message queues (Kafka)
- Replication systems
- Consensus protocols<br>
Example: Replication
1. Leader writes to WAL
2. WAL is replicated to followers
3. Once quorum acknowledges -> commit<br>
This makes WAL the backbone of replication and consistency<br>
In distributed systems, write-ahead logs are often replicated across multiple nodes. The leader appends changes to its WAL and propagates them to followers. Once a quorum acknowledges the log entries, the changes are considered committed, enabling strong consistency and fault tolerance.

### 7. Performance optimization in WAL
WAL sounds expensive - but systems optimize it heavily:
a) Group Commit

Batch multiple transactions into one log flush

b) Sequential Writes

WAL is append-only → very fast on disk

c) Checkpointing

Periodically flush all data pages to disk

Truncate old WAL entries

d) Async Data Writes

WAL sync is mandatory

Data page writes are delayed

Write-down paragraph

To improve performance, systems optimize WAL using techniques such as group commit, where multiple transactions share a single log flush, and checkpointing, where data pages are periodically written to disk to limit log growth. Since WAL writes are sequential, they are significantly faster than random data page writes.

### 8. Trade-offs and limitations
Pros:
- Strong durability
- Fast recovery
- Enables replication<br>
Cons:
- Extra disk writes
- Log management complexity
- Latency depends on fsync<br>
This is why some systems relax WAL for:
- Eventual consistency
- In-memory caches
- Analytics pipelines<br>
While WAL provides strong durability and crash recovery guarantees, it introduces additional write overhead and depends on disk flush latency. As a result, some systems trade off strict durability for higher performance by relaxing or batching WAL guarantees.

### 9. How to explain WAL in system design interview
30-second explanation (gold standard)
<pre> Write-Ahead Logging ensures durability by recording all changes in a persistent log before applying them to the database. In case of a crash, the system uses the log to redo committed transactions and ignore incomplete ones. This allows fast recovery, strong consistency, and safe replication, and is widely used in database and distributed systems.
</pre>
What interviewersr listen for:
- "Log first, data later"
- Crash recovery
- REDO vs UNDO
- Performance optimizations
- Trade-offs