# Apex Logger

A lightweight, dependency-free logging utility for Salesforce Apex, inspired by SLF4J-style logging.

Provides structured messages, placeholder interpolation, automatic execution context detection, and governor-limit monitoring.

## Features

- Six logging levels: `NONE`, `DEBUG`, `INFO`, `WARN`, `ERROR`, and `FATAL`
- SLF4J-style `{}` interpolation with up to five arguments
- Automatic Salesforce execution context detection
- Custom context labels
- Optional governor-limit monitoring
- Fatal exception handling
- No external dependencies

## Installation

Deploy from the repository root using Salesforce CLI:

```bash
sf project deploy start --source-dir projects/logger/main/default/classes
```

Requires an authenticated default Salesforce org.

## Usage

### Logging Levels

Logging methods use uppercase names to visually distinguish severity levels from configuration methods.

```apex
Logger.NONE('Message suppressed');
Logger.DEBUG('Processing started');
Logger.INFO('Successfully processed {} records', records.size());
Logger.WARN('Queue {} exceeded threshold {}', queueName, threshold);
Logger.ERROR('Failed to process record {}', recordId);
Logger.FATAL('Critical processing failure');
```

| Level | Behavior |
|---|---|
| `NONE` | No visible log output |
| `DEBUG` | Debugging information |
| `INFO` | General informational messages |
| `WARN` | Warnings and unexpected conditions |
| `ERROR` | Logs an error without throwing |
| `FATAL` | Throws `Logger.FatalException` |

Log visibility depends on Salesforce debug log settings.

### Message Interpolation

Use `{}` placeholders to insert values without string concatenation.

```apex
Logger.INFO('Processing {} Accounts', accounts.size());
Logger.DEBUG('User {} updated record {}', UserInfo.getName(), accountId);
Logger.WARN('Processed {} of {} records', processed, total);
Logger.ERROR('Feature enabled: {}', true);
```

Supports up to five arguments. Values are converted to strings, including null values.

### Execution Context

Logger automatically detects the Salesforce execution context using `Request.getCurrent().getQuiddity()`.

Example:

```text
[TRIGGER] Processing 5 Accounts
```

When context detection is unavailable, Logger uses `UNKNOWN`.

### Custom Context

Specify the originating class or method:

```apex
Logger.setContext('AccountTriggerHandler.afterInsert');
Logger.INFO('Processing {} Accounts', accounts.size());
Logger.clearContext();
```

Example:

```text
[TRIGGER][AccountTriggerHandler.afterInsert] Processing 5 Accounts
```

Suppress custom context labels:

```apex
Logger.setNoContext(true);
```

Restore them:

```apex
Logger.setNoContext(false);
```

This does not suppress the automatic Salesforce execution context.

### Governor Limits

Enable automatic governor-limit summaries:

```apex
Logger.showLimits();

Logger.INFO('Processing started');
Logger.DEBUG('Processing completed');

Logger.hideLimits();
```

Print a single summary:

```apex
Logger.limits();
```

Example:

```text
LIMITS [CPU 92/10000ms | DML 2/150 | SOQL 1/100 | Heap 18920/6000000]
```

Reported metrics include CPU time, DML statements, SOQL queries, and heap usage.

## Error Handling

### ERROR

`Logger.ERROR()` writes an error-level debug message without throwing an exception.

```apex
Logger.ERROR('Unable to process Account {}', accountId);
```

### FATAL

`Logger.FATAL()` always throws `Logger.FatalException`.

```apex
try {
    Logger.FATAL('Critical failure processing Account {}', accountId);
} catch (Logger.FatalException ex) {
    System.debug(ex.getMessage());
}
```

Fatal messages support the same placeholder interpolation as the other levels.

Unlike standard logging methods, `FATAL()` does not write a separate debug message before throwing.

## Configuration Reference

| Method | Description |
|---|---|
| `Logger.setContext(String)` | Sets a custom context label |
| `Logger.getContext()` | Returns the current custom context |
| `Logger.clearContext()` | Clears the custom context |
| `Logger.setNoContext(Boolean)` | Suppresses or restores custom context |
| `Logger.showLimits()` | Enables automatic governor-limit reporting |
| `Logger.hideLimits()` | Disables automatic governor-limit reporting |
| `Logger.limits()` | Prints a one-time governor-limit summary |

Configuration uses static state scoped to the current Apex transaction.

## Testing

Run the included `LoggerTest` class:

```bash
sf apex run test --tests LoggerTest --result-format human
```

Tests cover logging method overloads, message interpolation, fatal exceptions, special characters, context settings, and governor-limit reporting execution.

## Interactive Demo

Logger includes a demonstration utility for Execute Anonymous:

```apex
new Logger.Demo().run();
```

The demo exercises logging levels, execution context, interpolation, governor-limit summaries, and fatal exception handling.

The demonstration performs no DML operations and catches its simulated fatal exception.

## Requirements

- Salesforce org with Apex support
- Salesforce CLI for deployment
- Compatible Salesforce API version
