Simple index.php for FastCGI
<?php
/**
 * Simple index.php file for FastCGI
 */

// Check if the request was made via FastCGI
if (isset($_SERVER['FCGI_ROLE']) || isset($_SERVER['REDIRECT_FCGI_ROLE'])) {
    echo "<h1>FastCGI is working!</h1>";
} else {
    echo "<h1>This script is designed for FastCGI but appears to be running under a different handler.</h1>";
}

// Display some environment information
echo "<h2>Server Information</h2>";
echo "<ul>";
echo "<li>PHP Version: " . phpversion() . "</li>";
echo "<li>Server Software: " . $_SERVER['SERVER_SOFTWARE'] . "</li>";
echo "<li>Server Name: " . $_SERVER['SERVER_NAME'] . "</li>";
echo "<li>Request Method: " . $_SERVER['REQUEST_METHOD'] . "</li>";
echo "<li>Request Time: " . date('Y-m-d H:i:s', $_SERVER['REQUEST_TIME']) . "</li>";
echo "</ul>";

// Show all available FastCGI variables
echo "<h2>FastCGI Environment Variables</h2>";
echo "<pre>";
foreach ($_SERVER as $key => $value) {
    if (strpos($key, 'FCGI_') !== false || strpos($key, 'PHP_') !== false) {
        echo htmlspecialchars("$key: $value") . "\n";
    }
}
echo "</pre>";

// Example of a simple form handling
echo "<h2>Test Form</h2>";
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST)) {
    echo "<p>Form was submitted with the following data:</p>";
    echo "<pre>";
    print_r($_POST);
    echo "</pre>";
} else {
    ?>
    <form method="post" action="">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name"><br><br>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email"><br><br>
        
        <input type="submit" value="Submit">
    </form>
    <?php
}
?>
