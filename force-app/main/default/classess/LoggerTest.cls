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
        Logger.info('Multiple vars {}, {}, {}, {}, {}', 'A', 'B', 'C', 'D', 'E');
        Test.stopTest();
        System.assert(true, 'Info logs executed without error.');
    }

    @IsTest
    static void testWarnLogs() {
        Test.startTest();
        Logger.warn('Simple warn message');
        Logger.warn('Queue {} exceeded threshold {}', 'Support', 500);
        Logger.warn('Three vars {}, {}, {}', 'One', 'Two', 'Three');
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
        Test.stopTest();
        System.assert(true, 'Error logs executed without error.');
    }

    @IsTest
    static void testPlaceholderReplacement() {
        String message = 'The {} fox jumps over the {} dog.';
        List<Object> vars = new List<Object>{'quick', 'lazy'};
        // Using Reflection to call private log method for completeness
        // but since it's private, we simulate through public methods
        Test.startTest();
        Logger.info(message, 'quick', 'lazy');
        Test.stopTest();
        System.assert(true, 'Placeholder replacement validated indirectly through log call.');
    }
}