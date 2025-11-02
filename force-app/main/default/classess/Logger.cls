/**
 * @description  Custom Logger utility for structured, readable Apex logs.
 *
 * Features:
 * - Lightweight {} interpolation with up to five variables
 * - Automatic runtime context detection via Request.getQuiddity() 
 *   (e.g. ANONYMOUS, TRIGGER, BATCH_APEX, FUTURE, VISUALFORCE, etc.)
 * - Optional developer context via Logger.setContext('MyClass.myMethod')
 * - Suppress all context output with Logger.setNoContext(true)
 * - Toggle governor limit summary with Logger.showLimits() / Logger.hideLimits()
 * - Print a one-off resource summary with Logger.limits()
 *
 * Logging behavior:
 * - NONE, DEBUG, INFO, WARN → log only
 * - ERROR → log by default; optional overloads can throw
 * - FATAL → always throws (no System.debug to avoid duplicate log lines)
 *
 * Example usage:
 *     Logger.setContext('AccountTriggerHandler.handle');
 *     Logger.showLimits();
 *     Logger.info('Upserted {} Accounts', accounts.size());
 *     Logger.limits();
 *
 * Example output:
 *     [TRIGGER][AccountTriggerHandler.handle] Upserted 3 Accounts
 *     LIMITS [CPU 92/10000ms | DML 2/150 | SOQL 1/100 | Heap 18920/6000000]
 */

public with sharing class Logger {
    // ==== LOGGER CONTEXT OVERRIDES ====
    private static Boolean noContext = false;
    private static String contextOverride;

    public static String getContext() {
        if (noContext) return '';
        return contextOverride;
    }

    // ==== LOGGER LIMIT OVERRIDES ====
    private static Boolean showLimits = false;

    public static void showLimits() {
        showLimits = true;
    }

    public static void hideLimits() {
        showLimits = false;
    }

    public static void setContext(String value) { contextOverride = value; }
    public static void setNoContext(Boolean value) { noContext = value; }
    public static void clearContext() { contextOverride = null; }

    // ===== NONE =====
    public static void none(String message) { log(LoggingLevel.NONE, message, new List<Object>(), false); }
    public static void none(String message, Object v1) { log(LoggingLevel.NONE, message, new List<Object>{v1}, false); }
    public static void none(String message, Object v1, Object v2) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2}, false); }
    public static void none(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3}, false); }
    public static void none(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3, v4}, false); }
    public static void none(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3, v4, v5}, false); }

    // ===== DEBUG =====
    public static void debug(String message) { log(LoggingLevel.DEBUG, message, new List<Object>(), false); }
    public static void debug(String message, Object v1) { log(LoggingLevel.DEBUG, message, new List<Object>{v1}, false); }
    public static void debug(String message, Object v1, Object v2) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2}, false); }
    public static void debug(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3}, false); }
    public static void debug(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3, v4}, false); }
    public static void debug(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3, v4, v5}, false); }

    // ===== INFO =====
    public static void info(String message) { log(LoggingLevel.INFO, message, new List<Object>(), false); }
    public static void info(String message, Object v1) { log(LoggingLevel.INFO, message, new List<Object>{v1}, false); }
    public static void info(String message, Object v1, Object v2) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2}, false); }
    public static void info(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3}, false); }
    public static void info(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3, v4}, false); }
    public static void info(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3, v4, v5}, false); }

    // ===== WARN =====
    public static void warn(String message) { log(LoggingLevel.WARN, message, new List<Object>(), false); }
    public static void warn(String message, Object v1) { log(LoggingLevel.WARN, message, new List<Object>{v1}, false); }
    public static void warn(String message, Object v1, Object v2) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2}, false); }
    public static void warn(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3}, false); }
    public static void warn(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3, v4}, false); }
    public static void warn(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3, v4, v5}, false); }

    // ===== ERROR =====
    public static void error(String message) { log(LoggingLevel.ERROR, message, new List<Object>(), false); }
    public static void error(String message, Object v1) { log(LoggingLevel.ERROR, message, new List<Object>{v1}, false); }
    public static void error(String message, Object v1, Object v2) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2}, false); }
    public static void error(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3}, false); }
    public static void error(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4}, false); }
    public static void error(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4, v5}, false); }

    // Optional throw variants (explicit)
    public static void error(String message, Boolean throwException) { log(LoggingLevel.ERROR, message, new List<Object>(), throwException); }
    public static void error(String message, Object v1, Boolean throwException) { log(LoggingLevel.ERROR, message, new List<Object>{v1}, throwException); }
    public static void error(String message, Object v1, Object v2, Boolean throwException) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2}, throwException); }
    public static void error(String message, Object v1, Object v2, Object v3, Boolean throwException) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3}, throwException); }
    public static void error(String message, Object v1, Object v2, Object v3, Object v4, Boolean throwException) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4}, throwException); }
    public static void error(String message, Object v1, Object v2, Object v3, Object v4, Object v5, Boolean throwException) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4, v5}, throwException); }

    // ===== FATAL =====
    public static void fatal(String message) { throw new Logger.FatalException(interpolate(message, new List<Object>())); }
    public static void fatal(String message, Object v1) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1})); }
    public static void fatal(String message, Object v1, Object v2) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2})); }
    public static void fatal(String message, Object v1, Object v2, Object v3) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2, v3})); }
    public static void fatal(String message, Object v1, Object v2, Object v3, Object v4) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2, v3, v4})); }
    public static void fatal(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2, v3, v4, v5})); }

    // ===== Core =====
    private static void log(LoggingLevel level, String message, List<Object> vars, Boolean throwException) {
        if (String.isBlank(message)) return;

        String execCtx = getExecutionContext();
        String context = getContext();

        // Build clean prefix
        String prefix = '[' + execCtx;
        if (String.isNotBlank(context)) prefix += '][' + context;
        prefix += '] ';

        String finalMsg = prefix + interpolate(message, vars);

        if (throwException) throw new Logger.ErrorException(finalMsg);
        System.debug(level, finalMsg);

        if (showLimits && !throwException) {
            System.debug(level, buildLimitSummary());
        }
    }

    public static void limits() {
        System.debug(LoggingLevel.INFO, buildLimitSummary());
    }

    // ==== Helper Methods ====
    private static String interpolate(String message, List<Object> vars) {
        if (vars != null && !vars.isEmpty()) {
            for (Object var : vars) {
                String replacement = (var == null) ? 'null' : String.valueOf(var);
                message = message.replaceFirst('\\{\\}', replacement);
            }
        }
        return message;
    }

    private static String getExecutionContext() {
        try {
            Request req = Request.getCurrent();
            if (req != null && req.getQuiddity() != null) {
                return String.valueOf(req.getQuiddity());
            }
        } catch (Exception ex) {
            // ignore — not critical
        }
        return 'UNKNOWN';
    }

    private static String buildLimitSummary() {
        return 'LIMITS [' +
            'CPU ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime() + 'ms | ' +
            'DML ' + Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements() + ' | ' +
            'SOQL ' + Limits.getQueries() + '/' + Limits.getLimitQueries() + ' | ' +
            'Heap ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize() +
            ']';
    }

    // ===== Exceptions =====
    public class ErrorException extends Exception {}
    public class FatalException extends Exception {}

    // ===== Demo Utility =====
    public class Demo {
        /**
         * Run a live Logger demo showcasing all log levels, context, and limits.
         * Safe to run in Execute Anonymous or tests — no DML or side effects.
         *
         * Example:
         *     new Logger.Demo().run();
         */
        public void run() {
            Logger.setContext('Logger.Demo.run');
            Logger.showLimits();

            Logger.none('This is a NONE log');
            Logger.debug('Debugging user {}', UserInfo.getName());
            Logger.info('Processing record {} of {}', 1, 5);
            Logger.warn('Low remaining DML statements');
            Logger.error('Simulated error for record {}', '001XYZ');

            Logger.limits();

            try {
                Logger.fatal('Demo fatal exception — transaction ends here');
            } catch (Logger.FatalException ex) {
                System.debug('Caught FatalException: ' + ex.getMessage());
            }

            Logger.hideLimits();
            Logger.clearContext();
        }
    }
}
