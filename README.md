# redis-from-scratch-c

A Redis-compatible in-memory database built from scratch in C on Linux.

Every performance claim here is backed by a reproducible benchmark against real Redis.

## Status

Early development. Nothing to use yet.

## What it will do

- **TCP server with an event loop:** one thread serves many clients with non-blocking sockets.
- **Key-value commands:** `GET`, `SET`, `DEL`, plus sorted sets (`ZADD`, `ZRANGE`, ...).
- **Own data structures:** a resizable hashtable and a balanced binary tree, no libraries.
- **Expiry:** timers, idle-connection timeouts and keys with a time-to-live (TTL).
- **Thread pool:** large deletes run off the main thread.

## Beyond the tutorial

Parts of this project follow [Build Your Own Redis with C/C++](https://build-your-own.org/redis/).
These parts are my own additions:

- [ ] **Crash-safe persistence:** an append-only log flushed with `fsync`, replayed on startup, with crash tests that kill the server mid-write
- [ ] **Real Redis protocol (RESP):** so `redis-cli` and `redis-benchmark` work against it
- [ ] **epoll event loop:** and a comparison with `poll()` at 10,000 connections
- [ ] **Benchmarks:** requests per second and p50/p99 latency, side by side with real Redis

## Roadmap

- [ ] TCP server and client
- [ ] Request-response protocol
- [ ] Event loop with non-blocking IO
- [ ] Key-value server
- [ ] Hashtable with incremental resizing
- [ ] Data serialization
- [ ] Balanced binary tree and sorted set
- [ ] Timers, timeouts and TTL
- [ ] Thread pool

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
include/   headers
src/       server source
tests/     unit and crash tests
bench/     benchmarks
```

## License

MIT
