<?php
    
    require_once $_SERVER['DOCUMENT_ROOT'].'/photoVault/dbConnection/constants.php';
    require_once $_SERVER['DOCUMENT_ROOT'].'/photoVault/dbConnection/dbConnect.php';

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
               
        $db = new DbConnect ();
        $conn = $db->connect ();
        
        $stmt = $conn->prepare("SELECT `fp_code` FROM accountreset WHERE fp_code = ?;");
        $stmt->bind_param("s", $_POST['id']);
        $stmt->execute();
        $stmt->store_result();
        
        if ($stmt->num_rows > 0) {
            
            if ($_POST['password'] == $_POST['confirm_password']) {
                
                $options = [ 'cost' => 12 ];
                $password = password_hash($pass, PASSWORD_BCRYPT, $options) ;
                
                $stmt = $conn->prepare ("UPDATE users SET password = ? WHERE email = ?;");
                $stmt->bind_param ("ss", $_POST['password'], $_POST['email']) ;
                $stmt->execute () ;
                
                $stmt = $conn->prepare ("DELETE FROM accountreset WHERE fp_code = ?;");
                $stmt->bind_param ("s", $_POST['id']) ;
                $stmt->execute () ;
                
                echo "Password Updated" ;
                
            } else {
                
                echo "Password Fields Must Match" ;
                
            }
            
        } else {
            
            echo "Session Expired" ;
            
        }
        
    }
    
    ?>
