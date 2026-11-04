# tinykv-c

A small, crash-safe key-value store written in C11 for Linux.

The goal: writes survive a crash or power loss at any point, and every
performance claim is backed by a reproducible benchmark.

## Status

Early development. Nothing to use yet.

## Planned design

- **Write-ahead log (WAL):** every write is appended to a log and flushed
  with `fsync` before it is acknowledged.
- **Crash recovery:** on startup, replay the log and discard a torn
  final record (detected with a per-record checksum).
- **In-memory index:** hash table from key to log offset.
- **Compaction:** rewrite live keys to a new file, then swap it in
  atomically with `rename`.

## Roadmap

- [ ] Public API: `open`, `put`, `get`, `delete`, `close`
- [ ] Append-only log with CRC32 per record
- [ ] Recovery that tolerates a torn last write
- [ ] Crash tests (kill the process mid-write, verify no data loss)
- [ ] Benchmarks: throughput and p50/p99 latency, with and without `fsync`
- [ ] Compaction
- [ ] Concurrency (single writer, multiple readers)

## Build

```sh
make          # build
make test     # run tests
make bench    # run benchmarks
make asan     # build with AddressSanitizer + UBSan
make clean
```

Requires a C11 compiler (gcc or clang) and GNU make on Linux.

## Layout

```
include/   public header
src/       library source
tests/     unit and crash tests
bench/     benchmarks
```

## License

MIT
