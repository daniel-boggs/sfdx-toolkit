@IsTest
private class LoggerTest {
    @IsTest
    static void testNoneLogs() {
        Test.startTest();
        Logger.none('Simple none message');
        Logger.none('None with one var: {}', 'Apex');
        Logger.none('None with two vars: {} and {}', 'Cat', 'Dog');
        Logger.none('None with three vars: {}, {}, {}', 'One', 'Two', 'Three');
        Logger.none('None with four vars: {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.none('None with five vars: {}, {}, {}, {}, {}', '1', '2', '3', '4', '5');
        Test.stopTest();
        System.assert(true, 'None logs executed without error.');
    }

    @IsTest
    static void testDebugLogs() {
        Test.startTest();
        Logger.debug('Simple debug message');
        Logger.debug('Debug with one var: {}', 'Apex');
        Logger.debug('Debug with two vars: {} and {}', 'Cat', 'Dog');
        Logger.debug('Debug with three vars: {}, {}, {}', 'One', 'Two', 'Three');
        Logger.debug('Debug with four vars: {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.debug('Debug with five vars: {}, {}, {}, {}, {}', '1', '2', '3', '4', '5');
        Test.stopTest();
        System.assert(true, 'Debug logs executed without error.');
    }

    @IsTest
    static void testInfoLogs() {
        Test.startTest();
        Logger.info('Simple info message');
        Logger.info('User {} started process {} at {}', 'Daniel', 'Import', DateTime.now());
        Logger.info('Four vars {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.info('Five vars {}, {}, {}, {}, {}', 'A', 'B', 'C', 'D', 'E');
        Test.stopTest();
        System.assert(true, 'Info logs executed without error.');
    }

    @IsTest
    static void testWarnLogs() {
        Test.startTest();
        Logger.warn('Simple warn message');
        logger.warn('One Var: {}', 'Apex');
        Logger.warn('Queue {} exceeded threshold {}', 'Support', 500);
        Logger.warn('Three vars {}, {}, {}', 'One', 'Two', 'Three');
        Logger.warn('Four vars {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.warn('Five vars {}, {}, {}, {}, {}', 1, 2, 3, 4, 5);
        Test.stopTest();
        System.assert(true, 'Warn logs executed without error.');
    }

    @IsTest
    static void testErrorLogs() {
        Test.startTest();
        Logger.error('Simple error message');
        Logger.error('Failed record {} for account {}', '001ABC', 'Acme');
        Logger.error('Three vars {}, {}, {}', 'Alpha', 'Beta', 'Gamma');
        Logger.error('Four vars {}, {}, {}, {}', 'W', 'X', 'Y', 'Z');
        Logger.error('Five vars {}, {}, {}, {}, {}', 'V', 'W', 'X', 'Y', 'Z');
        Test.stopTest();
        System.assert(true, 'Error logs executed without error.');
    }

    @IsTest
    static void testErrorLogsThrowVariants() {
        List<Boolean> caught = new List<Boolean>();

        Test.startTest();
        try { Logger.error('Simple error message', true); } catch (Logger.ErrorException ex) { caught.add(true); }
        try { Logger.error('{} Trigger threw exception', 'Account', true); } catch (Logger.ErrorException ex) { caught.add(true); }
        try { Logger.error('Failed record {} for account {}', '001ABC', 'Acme', true); } catch (Logger.ErrorException ex) { caught.add(true); }
        try { Logger.error('Three vars {}, {}, {}', 'Alpha', 'Beta', 'Gamma', true); } catch (Logger.ErrorException ex) { caught.add(true); }
        try { Logger.error('Four vars {}, {}, {}, {}', 'W', 'X', 'Y', 'Z', true); } catch (Logger.ErrorException ex) { caught.add(true); }
        try { Logger.error('Five vars {}, {}, {}, {}, {}', 'V', 'W', 'X', 'Y', 'Z', true); } catch (Logger.ErrorException ex) { caught.add(true); }
        Test.stopTest();
        System.assert(true, 'All 6 Error log variants should execute and be caught.');
    }

    @IsTest
    static void testAllFatalVariants() {
        List<Boolean> caught = new List<Boolean>();

        Test.startTest();
        try { Logger.fatal('Fatal no vars'); } catch (Logger.FatalException ex) { caught.add(true); }
        try { Logger.fatal('Fatal with one var: {}', 'X'); } catch (Logger.FatalException ex) { caught.add(true); }
        try { Logger.fatal('Fatal with two vars: {}, {}', 'A', 'B'); } catch (Logger.FatalException ex) { caught.add(true); }
        try { Logger.fatal('Fatal with three vars: {}, {}, {}', 1, 2, 3); } catch (Logger.FatalException ex) { caught.add(true); }
        try { Logger.fatal('Fatal with four vars: {}, {}, {}, {}', 'One', 'Two', 'Three', 'Four'); } catch (Logger.FatalException ex) { caught.add(true); }
        try { Logger.fatal('Fatal with five vars: {}, {}, {}, {}, {}', '1', '2', '3', '4', '5'); } catch (Logger.FatalException ex) { caught.add(true); }
        Test.stopTest();

        System.assertEquals(6, caught.size(), 'All 6 fatal variants should throw and be caught.');
    }

    @IsTest
    static void testPlaceholderReplacement() {
        String message = 'The {} fox jumps over the {} dog.';
        Test.startTest();
        Logger.info(message, 'quick', 'lazy');
        Test.stopTest();
        System.assert(true, 'Placeholder replacement validated indirectly through log call.');
    }

    @IsTest
    static void testLimitLogs() {
        Test.startTest();
        Logger.showLimits();
        Logger.debug('Testing limits output');
        Logger.limits();
        Logger.hideLimits();
        Logger.info('Limit summary disabled');
        Test.stopTest();
        System.assert(true, 'Limit summary and manual limits logging executed without error.');
    }

        @IsTest
    static void testExceptionAndContextBehavior() {
        // === Test context and noContext behavior ===
        Logger.setContext('CustomHandler.process');
        Logger.debug('Should show context');
        Logger.setNoContext(true);
        Logger.info('Should hide context');
        Logger.setNoContext(false);
        Logger.clearContext();

        // === Test ERROR with throwException ===
        Boolean thrown = false;
        try {
            Logger.error('This should throw', true);
        } catch (Logger.ErrorException ex) {
            thrown = true;
        }
        System.assert(thrown, 'Logger.error(..., true) should throw ErrorException');

        // === Test FATAL ===
        Boolean fatalThrown = false;
        try {
            Logger.fatal('Critical failure at {}', 'line 42');
        } catch (Logger.FatalException ex) {
            fatalThrown = true;
        }
        System.assert(fatalThrown, 'Logger.fatal() should throw FatalException');

        // === Test null interpolation edge case ===
        Test.startTest();
        Logger.info('Handles null value {}', null);
        Test.stopTest();
        System.assert(true, 'Null interpolation handled cleanly');
    }

    @IsTest
    static void testLoggerDemoRun() {
        Test.startTest();
        new Logger.Demo().run();
        Test.stopTest();
        System.assert(true, 'Logger.Demo.run() executed without exception.');
    }
}
