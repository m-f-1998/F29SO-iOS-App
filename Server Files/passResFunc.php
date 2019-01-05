<?php
    
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        
        require_once $_SERVER['DOCUMENT_ROOT'].'/login/fixed/constants.php';
        require_once $_SERVER['DOCUMENT_ROOT'].'/login/fixed/dbConnect.php';
        
        $db = new DbConnect ();
        $conn = $db->connect ();
        
        $stmt = $conn->prepare("SELECT `id` FROM passwordreset WHERE id = ?;");
        $stmt->bind_param("s", $_POST['id']);
        $stmt->execute();
        $stmt->store_result();

        echo ($stmt->num_rows);
        
        if ($stmt->num_rows > 0) {
            
            if ($_POST['password'] == $_POST['confirm_password']) {
                
                $options = [ 'cost' => 12 ];
                $password = password_hash($pass, PASSWORD_BCRYPT, $options) ;
                
                $stmt = $conn->prepare ("UPDATE users SET password = ? WHERE email = ?;");
                $stmt->bind_param ("ss", $_POST['password'], $_POST['email']) ;
                $stmt->execute () ;
                
                $stmt = $conn->prepare ("DELETE FROM passwordreset WHERE id = ?;");
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
