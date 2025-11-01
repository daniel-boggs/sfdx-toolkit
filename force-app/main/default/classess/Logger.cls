/**
 * @description Custom Logger utility for clean, formatted debug output.
 * Supports lightweight {} interpolation with up to five variables.
 *
 * Example usage:
 *     Loggger.debug('Apex {} Trigger is running.', triggerName);
 *     Logger.info('User {} started process {} at {}', userName, processName, startTime);
 *     Logger.warn('Email list {} is inactive.', listName);
 *     Logger.error('Failed to process record {} for account {}', recordId, accountName);
 */
public with sharing class Logger {
    // === Public NONE Methods ===
    public static void none(String message)                     { log(LoggingLevel.NONE, message, new List<Object>()); }
    public static void none(String message, Object v1)          { log(LoggingLevel.NONE, message, new List<Object>{v1}); }
    public static void none(String message, Object v1, Object v2) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2}); }
    public static void none(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3}); }
    public static void none(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3, v4}); }
    public static void none(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.NONE, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // === Public DEBUG Methods ===
    public static void debug(String message)                     { log(LoggingLevel.DEBUG, message, new List<Object>()); }
    public static void debug(String message, Object v1)          { log(LoggingLevel.DEBUG, message, new List<Object>{v1}); }
    public static void debug(String message, Object v1, Object v2) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2}); }
    public static void debug(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3}); }
    public static void debug(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3, v4}); }
    public static void debug(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.DEBUG, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // === Public INFO Methods ===
    public static void info(String message)                     { log(LoggingLevel.INFO, message, new List<Object>()); }
    public static void info(String message, Object v1)          { log(LoggingLevel.INFO, message, new List<Object>{v1}); }
    public static void info(String message, Object v1, Object v2) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2}); }
    public static void info(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3}); }
    public static void info(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3, v4}); }
    public static void info(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.INFO, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // === Public WARN Methods ===
    public static void warn(String message)                     { log(LoggingLevel.WARN, message, new List<Object>()); }
    public static void warn(String message, Object v1)          { log(LoggingLevel.WARN, message, new List<Object>{v1}); }
    public static void warn(String message, Object v1, Object v2) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2}); }
    public static void warn(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3}); }
    public static void warn(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3, v4}); }
    public static void warn(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.WARN, message, new List<Object>{v1, v2, v3, v4, v5}); }

    // === Public ERROR Methods ===
    public static void error(String message)                     { log(LoggingLevel.ERROR, message, new List<Object>()); }
    public static void error(String message, Object v1)          { log(LoggingLevel.ERROR, message, new List<Object>{v1}); }
    public static void error(String message, Object v1, Object v2) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2}); }
    public static void error(String message, Object v1, Object v2, Object v3) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3}); }
    public static void error(String message, Object v1, Object v2, Object v3, Object v4) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4}); }
    public static void error(String message, Object v1, Object v2, Object v3, Object v4, Object v5) { log(LoggingLevel.ERROR, message, new List<Object>{v1, v2, v3, v4, v5}); }

    /**
     * Core log method shared by all others.
     * Replaces each {} placeholder with the corresponding variable.
     */
    private static void log(LoggingLevel level, String message, List<Object> vars) {
        if (vars != null && !vars.isEmpty()) {
            for (Object var : vars) {
                // Replace the first occurrence of {} in order
                message = message.replaceFirst('\\{\\}', String.valueOf(var));
            }
        }
        System.debug(level, message);
    }
}
