<?php
    //header('Content-Type: text/plain');
    session_start();
    setcookie("prologue","uic" );
?>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>Simple PHP App</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <style>body {margin-top: 40px; background-color: #333;}</style>
        <!--[if lt IE 9]><script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
    </head>

    <body>
        <div class="container">
            <div class="jumbotron">
                <h1>Simple PHP App</h1>
                <h2>Congratulations!</h2>

                <ul>
                    <li>Your PHP application is now running on the host &ldquo;<?php echo gethostname(); ?></li>
                    <li>This host is running PHP version <?php echo phpversion(); ?>.</li>
                    <li><?php echo "Server IP: ".$_SERVER['SERVER_ADDR']; ?></li>
                    <li><?php echo "Client IP: ".$_SERVER['REMOTE_ADDR']; ?></li>
                    <li><?php echo "X-Forwarded-for: ".$_SERVER['HTTP_X_FORWARDED_FOR']; ?></li>
                    
                    <?php
                        if(!isset($_SESSION['visit']))
                        {
                            echo "<li> This is the first time you're visiting this server </li>";
                            $_SESSION['ssh visit'] = 0;
                        }
                        else
                        {
                            echo " <li>Your number of visits: ".$_SESSION['visit']."</li>";
                        }

                        $_SESSION['visit']++;

                        foreach($_COOKIE as $key=>$value)
                        {
                            echo "<li>".$key. " => " .$value. "</li>";
                        }
                    ?>
                </ul>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </body>
</html>
