# Apex Logger

A lightweight, dependency-free logging utility for Salesforce Apex, inspired by SLF4J-style logging.

Provides structured logging, message interpolation, execution context detection, and governor-limit monitoring without additional Salesforce configuration or dependencies.

## Features

- Six logging levels: `NONE`, `DEBUG`, `INFO`, `WARN`, `ERROR`, and `FATAL`
- `{}` placeholder interpolation with up to five arguments
- Automatic Salesforce execution context detection
- Custom context labels for easier debugging
- Optional governor-limit reporting
- Error and fatal exception handling
- No external dependencies

## Installation

Clone the repository or download the Logger project.

Deploy using Salesforce CLI from the repository root:

```bash
sf project deploy start --source-dir projects/logger/main/default/classes
```

An authenticated default Salesforce org is required.

## Usage

### Logging Levels

Logging methods follow an uppercase naming convention to visually distinguish severity levels from configuration methods.

```apex
Logger.NONE('Unclassified message');
Logger.DEBUG('Processing started');
Logger.INFO('Records successfully processed');
Logger.WARN('Processing threshold approaching');
Logger.ERROR('Failed to process record');
Logger.FATAL('Critical processing failure');
```

| Level | Behavior |
|---|---|
| `NONE` | Passes a message to Salesforce's `NONE` debug level |
| `DEBUG` | General debugging information |
| `INFO` | Informational messages |
| `WARN` | Potential problems or unexpected conditions |
| `ERROR` | Error logging, with optional exception throwing |
| `FATAL` | Always throws `Logger.FatalException` |

Log visibility depends on Salesforce debug log settings. Logger does not implement its own severity filtering.

### Message Interpolation

Use `{}` placeholders to insert values without string concatenation.

```apex
Logger.INFO('Processing {} Accounts', accounts.size());
Logger.DEBUG('User {} updated record {}', UserInfo.getName(), accountId);
Logger.WARN('Processed {} of {} records', processed, total);
```

Supports up to five arguments per message.

Null arguments are rendered as `null`.

### Execution Context

Logger automatically determines the current Salesforce execution context using `Request.getCurrent().getQuiddity()`.

Example output:

```text
[TRIGGER] Processing 5 Accounts
```

Context values depend on how Apex is executing, such as `TRIGGER`, `BATCH_APEX`, or `ANONYMOUS`.

If the execution context cannot be determined, Logger uses `UNKNOWN`.

### Custom Context

Specify the originating class or method to make logs easier to identify.

```apex
Logger.setContext('AccountTriggerHandler.afterInsert');
Logger.INFO('Processing {} Accounts', accounts.size());
Logger.clearContext();
```

Example output:

```text
[TRIGGER][AccountTriggerHandler.afterInsert] Processing 5 Accounts
```

To suppress custom context labels:

```apex
Logger.setNoContext(true);
```

Restore custom context labels:

```apex
Logger.setNoContext(false);
```

The Salesforce execution context prefix remains visible.

### Governor Limits

Enable automatic governor-limit reporting after each standard logging call.

```apex
Logger.showLimits();

Logger.INFO('Processing started');
Logger.DEBUG('Processing completed');

Logger.hideLimits();
```

Alternatively, print a one-time summary:

```apex
Logger.limits();
```

Example output:

```text
LIMITS [CPU 92/10000ms | DML 2/150 | SOQL 1/100 | Heap 18920/6000000]
```

Reported metrics include CPU time, DML statements, SOQL queries, and heap usage.

## Exception Handling

### Error Logging

By default, `Logger.ERROR()` writes a debug message without interrupting execution.

```apex
Logger.ERROR('Unable to process Account {}', accountId);
```

Pass `true` as the final argument to throw `Logger.ErrorException`.

```apex
Logger.ERROR('Unable to process Account {}', accountId, true);
```

### Fatal Errors

`Logger.FATAL()` always throws `Logger.FatalException`.

```apex
Logger.FATAL('Critical processing failure for {}', accountId);
```

Unlike other logging levels, fatal calls do not write a separate `System.debug()` message before throwing.

## Configuration Reference

| Method | Description |
|---|---|
| `Logger.setContext(String)` | Assigns a custom context label |
| `Logger.getContext()` | Returns the current custom context |
| `Logger.clearContext()` | Clears the custom context |
| `Logger.setNoContext(Boolean)` | Suppresses or restores custom context |
| `Logger.showLimits()` | Enables governor-limit reporting |
| `Logger.hideLimits()` | Disables automatic limit reporting |
| `Logger.limits()` | Outputs a one-time governor-limit summary |

Configuration is maintained using static variables within the current Apex transaction.

## Testing

Run the included test class:

```bash
sf apex run test --tests LoggerTest --result-format human
```

### Interactive Demo

Logger includes a demonstration utility covering logging levels, interpolation, context handling, governor limits, and fatal exception handling.

Run using Execute Anonymous:

```apex
new Logger.Demo().run();
```

The demonstration performs no DML operations and catches its simulated fatal exception.

## Requirements

- Salesforce org with Apex support
- Salesforce CLI for command-line deployment
- Compatible Salesforce API version

## License

See the repository's license file, if provided.