
@IsTest
private class LoggerTest {
    @IsTest
    static void testNoneLogs() {
        Test.startTest();
        Logger.NONE('Simple none message');
        Logger.NONE('None with one var: {}', 'Apex');
        Logger.NONE('None with two vars: {} and {}', 'Cat', 'Dog');
        Logger.NONE('None with three vars: {}, {}, {}', 'One', 'Two', 'Three');
        Logger.NONE('None with four vars: {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.NONE('None with five vars: {}, {}, {}, {}, {}', '1', '2', '3', '4', '5');
        Test.stopTest();
    }

    @IsTest
    static void testDebugLogs() {
        Test.startTest();
        Logger.DEBUG('Simple debug message');
        Logger.DEBUG('Debug with one var: {}', 'Apex');
        Logger.DEBUG('Debug with two vars: {} and {}', 'Cat', 'Dog');
        Logger.DEBUG('Debug with three vars: {}, {}, {}', 'One', 'Two', 'Three');
        Logger.DEBUG('Debug with four vars: {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.DEBUG('Debug with five vars: {}, {}, {}, {}, {}', '1', '2', '3', '4', '5');
        Test.stopTest();
    }

    @IsTest
    static void testInfoLogs() {
        Test.startTest();
        Logger.INFO('Simple info message');
        Logger.INFO('Info with one var: {}', 'Apex');
        Logger.INFO('Info with two vars: {} and {}', 'Cat', 'Dog');
        Logger.INFO('User {} started process {} at {}', 'Daniel', 'Import', DateTime.now());
        Logger.INFO('Four vars {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.INFO('Five vars {}, {}, {}, {}, {}', 'A', 'B', 'C', 'D', 'E');
        Test.stopTest();
    }

    @IsTest
    static void testWarnLogs() {
        Test.startTest();
        Logger.WARN('Simple warn message');
        Logger.WARN('One Var: {}', 'Apex');
        Logger.WARN('Queue {} exceeded threshold {}', 'Support', 500);
        Logger.WARN('Three vars {}, {}, {}', 'One', 'Two', 'Three');
        Logger.WARN('Four vars {}, {}, {}, {}', 'A', 'B', 'C', 'D');
        Logger.WARN('Five vars {}, {}, {}, {}, {}', 1, 2, 3, 4, 5);
        Test.stopTest();
    }

    @IsTest
    static void testErrorLogs() {
        Test.startTest();
        Logger.ERROR('Simple error message');
        Logger.ERROR('Error with one var: {}', 'Apex');
        Logger.ERROR('Failed record {} for account {}', '001ABC', 'Acme');
        Logger.ERROR('Three vars {}, {}, {}', 'Alpha', 'Beta', 'Gamma');
        Logger.ERROR('Four vars {}, {}, {}, {}', 'W', 'X', 'Y', 'Z');
        Logger.ERROR('Five vars {}, {}, {}, {}, {}', 'V', 'W', 'X', 'Y', 'Z');
        Logger.ERROR('Boolean interpolation: {}', true);
        Test.stopTest();
    }

    @IsTest
    static void testAllFatalVariants() {
        List<String> messages = new List<String>();

        Test.startTest();
        try { Logger.FATAL('Fatal no vars'); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Fatal with one var: {}', 'X'); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Fatal with two vars: {}, {}', 'A', 'B'); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Fatal with three vars: {}, {}, {}', 1, 2, 3); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Fatal with four vars: {}, {}, {}, {}', 'One', 'Two', 'Three', 'Four'); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Fatal with five vars: {}, {}, {}, {}, {}', '1', '2', '3', '4', '5'); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        Test.stopTest();

        Assert.areEqual(6, messages.size(), 'All 6 FATAL variants should throw.');
        Assert.areEqual('Fatal no vars', messages[0]);
        Assert.areEqual('Fatal with one var: X', messages[1]);
        Assert.areEqual('Fatal with two vars: A, B', messages[2]);
        Assert.areEqual('Fatal with three vars: 1, 2, 3', messages[3]);
        Assert.areEqual('Fatal with four vars: One, Two, Three, Four', messages[4]);
        Assert.areEqual('Fatal with five vars: 1, 2, 3, 4, 5', messages[5]);
    }

    @IsTest
    static void testPlaceholderReplacement() {
        String actualMessage;

        Test.startTest();
        try {
            Logger.FATAL('The {} fox jumps over the {} dog.', 'quick', 'lazy');
        } catch (Logger.FatalException ex) {
            actualMessage = ex.getMessage();
        }
        Test.stopTest();

        Assert.areEqual('The quick fox jumps over the lazy dog.', actualMessage, 'Placeholders should be replaced in order.');
    }

    @IsTest
    static void testSpecialCharacterInterpolation() {
        List<String> messages = new List<String>();

        Test.startTest();
        try { Logger.FATAL('Price: {}', '$25'); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Path: {}', 'C:\\Logs\\Archive'); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Null value: {}', null); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        try { Logger.FATAL('Boolean value: {}', true); } catch (Logger.FatalException ex) { messages.add(ex.getMessage()); }
        Test.stopTest();

        Assert.areEqual(4, messages.size(), 'All interpolation cases should throw.');
        Assert.areEqual('Price: $25', messages[0]);
        Assert.areEqual('Path: C:\\Logs\\Archive', messages[1]);
        Assert.areEqual('Null value: null', messages[2]);
        Assert.areEqual('Boolean value: true', messages[3]);
    }

    @IsTest
    static void testLimitLogs() {
        Test.startTest();
        Logger.showLimits();
        Logger.DEBUG('Testing limits output');
        Logger.limits();
        Logger.hideLimits();
        Logger.INFO('Limit summary disabled');
        Test.stopTest();
    }

    @IsTest
    static void testContextBehavior() {
        Test.startTest();

        // === Test context and noContext behavior ===
        Logger.setContext('CustomHandler.process');
        Assert.areEqual('CustomHandler.process', Logger.getContext(), 'Custom context should be available.');

        Logger.DEBUG('Should show context');

        Logger.setNoContext(true);
        Assert.areEqual('', Logger.getContext(), 'Custom context should be suppressed.');

        Logger.INFO('Should hide context');

        Logger.setNoContext(false);
        Assert.areEqual('CustomHandler.process', Logger.getContext(), 'Custom context should be restored.');

        Logger.clearContext();
        Assert.isNull(Logger.getContext(), 'Custom context should be cleared.');

        Test.stopTest();
    }

    @IsTest
    static void testSingleObjectOverloads() {
        Test.startTest();
        Logger.NONE(100);
        Logger.DEBUG(100);
        Logger.INFO(true);
        Logger.WARN(100);
        Logger.ERROR(false);
        Test.stopTest();
    }

    @IsTest
    static void testFatalObjectOverload() {
        String actualMessage;

        Test.startTest();
        try {
            Logger.FATAL(100);
        } catch (Logger.FatalException ex) {
            actualMessage = ex.getMessage();
        }
        Test.stopTest();

        Assert.areEqual('100', actualMessage, 'FATAL should convert object values to strings.');
    }

    @IsTest
    static void testLoggerDemoRun() {
        Test.startTest();
        new Logger.Demo().run();
        Test.stopTest();

        Assert.isNull(Logger.getContext(), 'Demo should clear its custom context.');
    }
}
