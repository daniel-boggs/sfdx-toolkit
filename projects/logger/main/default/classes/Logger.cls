
/**
 * @description  Custom Logger utility for structured, readable Apex logs.
 *
 * Features:
 * - Lightweight {} interpolation with up to five variables
 * - Automatic runtime context detection via Request.getCurrent().getQuiddity()
 *   (e.g. ANONYMOUS, TRIGGER, BATCH_APEX, FUTURE, VISUALFORCE, etc.)
 * - Optional developer context via Logger.setContext('MyClass.myMethod')
 * - Suppress custom context output with Logger.setNoContext(true)
 * - Toggle governor limit summary with Logger.showLimits() / Logger.hideLimits()
 * - Print a one-off resource summary with Logger.limits()
 *
 * Logging behavior:
 * - NONE → no visible log output
 * - DEBUG, INFO, WARN, ERROR → log only
 * - FATAL → always throws (no System.debug to avoid duplicate log lines)
 *
 * Example usage:
 *     Logger.setContext('AccountTriggerHandler.handle');
 *     Logger.showLimits();
 *     Logger.INFO('Upserted {} Accounts', accounts.size());
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

    // ===== SINGLE OBJECT OVERLOADS =====
    // Enables Logger.DEBUG(list.size()), Logger.INFO(false), etc.
    public static void NONE(Object v) { log(LoggingLevel.NONE, String.valueOf(v), new List<Object>()); }
    public static void DEBUG(Object v) { log(LoggingLevel.DEBUG, String.valueOf(v), new List<Object>()); }
    public static void INFO(Object v) { log(LoggingLevel.INFO, String.valueOf(v), new List<Object>()); }
    public static void WARN(Object v) { log(LoggingLevel.WARN, String.valueOf(v), new List<Object>()); }
    public static void ERROR(Object v) { log(LoggingLevel.ERROR, String.valueOf(v), new List<Object>()); }
    public static void FATAL(Object v) { throw new Logger.FatalException(String.valueOf(v)); }

    // ===== MULTI-VARIABLE OVERLOADS =====
    // ===== NONE =====
    public static void NONE(String message) { log(LoggingLevel.NONE, message, new List<Object>()); }
    public static void NONE(String message, Object v1) { log(LoggingLevel.NONE, message, new List<Object>{v1}); }
    public static void NONE(String message, Object v1, Object v2) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2}); }
    public static void NONE(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3}); }
    public static void NONE(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3, v4}); }
    public static void NONE(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // ===== DEBUG =====
    public static void DEBUG(String message) { log(LoggingLevel.DEBUG, message, new List<Object>()); }
    public static void DEBUG(String message, Object v1) { log(LoggingLevel.DEBUG, message, new List<Object>{v1}); }
    public static void DEBUG(String message, Object v1, Object v2) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2}); }
    public static void DEBUG(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3}); }
    public static void DEBUG(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3, v4}); }
    public static void DEBUG(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // ===== INFO =====
    public static void INFO(String message) { log(LoggingLevel.INFO, message, new List<Object>()); }
    public static void INFO(String message, Object v1) { log(LoggingLevel.INFO, message, new List<Object>{v1}); }
    public static void INFO(String message, Object v1, Object v2) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2}); }
    public static void INFO(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3}); }
    public static void INFO(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3, v4}); }
    public static void INFO(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // ===== WARN =====
    public static void WARN(String message) { log(LoggingLevel.WARN, message, new List<Object>()); }
    public static void WARN(String message, Object v1) { log(LoggingLevel.WARN, message, new List<Object>{v1}); }
    public static void WARN(String message, Object v1, Object v2) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2}); }
    public static void WARN(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3}); }
    public static void WARN(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3, v4}); }
    public static void WARN(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // ===== ERROR =====
    public static void ERROR(String message) { log(LoggingLevel.ERROR, message, new List<Object>()); }
    public static void ERROR(String message, Object v1) { log(LoggingLevel.ERROR, message, new List<Object>{v1}); }
    public static void ERROR(String message, Object v1, Object v2) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2}); }
    public static void ERROR(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3}); }
    public static void ERROR(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4}); }
    public static void ERROR(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // ===== FATAL =====
    public static void FATAL(String message) { throw new Logger.FatalException(interpolate(message, new List<Object>())); }
    public static void FATAL(String message, Object v1) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1})); }
    public static void FATAL(String message, Object v1, Object v2) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2})); }
    public static void FATAL(String message, Object v1, Object v2, Object v3) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2, v3})); }
    public static void FATAL(String message, Object v1, Object v2, Object v3, Object v4) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2, v3, v4})); }
    public static void FATAL(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { throw new Logger.FatalException(interpolate(message, new List<Object>{v1, v2, v3, v4, v5})); }

    // ===== Core =====
    private static void log(LoggingLevel level, String message, List<Object> vars) {
        if (String.isBlank(message)) return;

        String execCtx = getExecutionContext();
        String context = getContext();

        // Build clean prefix
        String prefix = '[' + execCtx;
        if (String.isNotBlank(context)) prefix += '][' + context;
        prefix += '] ';

        String finalMsg = prefix + interpolate(message, vars);

        System.debug(level, finalMsg);

        if (showLimits) {
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
                replacement = replacement.replace('\\', '\\\\').replace('$', '\\$');
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

            Logger.NONE('This is a NONE log--you won\'t ever see it!');
            Logger.DEBUG('Debugging user {}', UserInfo.getName());
            Logger.INFO('Processing record {} of {}', 1, 5);
            Logger.WARN('Low remaining DML statements');
            Logger.ERROR('Simulated error for record {}', '001XYZ');

            Logger.limits();

            try {
                Logger.FATAL('Demo fatal exception — transaction ends here');
            } catch (Logger.FatalException ex) {
                System.debug('Caught FatalException: ' + ex.getMessage());
            }

            Logger.hideLimits();
            Logger.clearContext();
        }
    }
}
