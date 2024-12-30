import 'package:selenium/selenium.dart';
import 'package:test/test.dart';

void main() {
  late WebDriver driver;
  
  setUp(() async {
    driver = await createDriver();
  });

  tearDown(() async {
    await driver.quit();
  });

  test('Login Page Test', () async {
    // Navigate to the login page
    await driver.get('http://localhost:8000');  // Adjust URL to your local Flutter Web app

    // Find the email input field and enter an email
    WebElement emailInput = await driver.findElement(By.cssSelector('input[type="email"]'));
    await emailInput.sendKeys('test@example.com');

    // Find the password input field and enter the password
    WebElement passwordInput = await driver.findElement(By.cssSelector('input[type="password"]'));
    await passwordInput.sendKeys('password123');

    // Find and click the login button
    WebElement loginButton = await driver.findElement(By.cssSelector('button[type="submit"]'));
    await loginButton.click();

    // Wait for a response (could be success or failure message)
    await driver.waitFor(By.cssSelector('.snackbar-success'));

    // Check that a success message is displayed
    WebElement successMessage = await driver.findElement(By.cssSelector('.snackbar-success'));
    expect(await successMessage.text, 'Logged in successfully!');
  });
}
