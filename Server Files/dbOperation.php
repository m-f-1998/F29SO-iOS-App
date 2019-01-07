<?php

class dbOperation {
    
    private $conn;
 
    function __construct () {
        
        require_once $_SERVER['DOCUMENT_ROOT'].'/login/fixed/constants.php';
        require_once $_SERVER['DOCUMENT_ROOT'].'/login/fixed/dbConnect.php';
        
        $db = new DbConnect ();
        $this->conn = $db->connect ();
        
    }
 
    public function userLogin ($email, $pass) {

        $stmt = $this->conn->prepare ("SELECT password FROM users WHERE email = ?;");
        $stmt->bind_param ("s", $email);
        $stmt->execute ();
        $stmt->bind_result ($password);
        $stmt->fetch();
        return password_verify($pass, $password);
    
    }
 
    public function createUser ($email, $pass) {
        
        if (!$this->isUserExist ($email, $pass)) {
            
            $options = [
                'cost' => 12,
            ];
            $password = password_hash($pass, PASSWORD_BCRYPT, $options);
            $stmt = $this->conn->prepare ("INSERT INTO users (email, password) VALUES (?, ?);");
            $stmt->bind_param ("ss", $email, $password) ;
            
            if ($stmt->execute ()) { return USER_CREATED; } else { echo $stmt->error; return USER_NOT_CREATED; }
            
        } else {
            return USER_ALREADY_EXIST;
        }
        
    }
    
    public function resetPass ($email) {
        
        if ($this->isUserExist ($email)) {
            
            $code = md5(uniqid(mt_rand())) ;
            $uniqueLink = "http://www.matthewfrankland.co.uk/login/resetPass.php?fp_code=".$code ;
            $subject = "Password Update Request => Pedal Pay" ;
            $headers = "MIME-Version: 1.0" . "\r\nContent-type:text/html;charset=UTF-8" . "\r\nFrom: PedalPay<noReply@pedalpay.com>" . "\r\n" ;
            $mailContent = 'Recently a request was submitted to reset a password for your account. If this was a mistake, please destroy this email without any further action.<br/>To reset your password, visit the following link: <a href="'.$uniqueLink.'">'.$uniqueLink.'</a><br/><br/>Regards,<br/>Pedal Pay' ;
            
            $stmt = $this->conn->prepare("INSERT INTO accountreset VALUES (?, UNIX_TIMESTAMP());") ;
            $stmt->bind_param("s", $code) ;
            $stmt->execute() ;
            mail($email,$subject,$mailContent,$headers) ;
            
            return true ;
            
        } else {
            
            return false ;
            
        }
                
    }
    
    public function getLocations () {
        
        $stmt = $this->conn->query ("SELECT hub, lat, lng FROM locations;");
        $res = array();
        while ($data = $stmt->fetch_assoc()) {
            array_push($res, $data);
        }
        return $res;
        
    }
 
 
    private function isUserExist ($email) {
        
        $stmt = $this->conn->prepare("SELECT id FROM users WHERE email = ?;");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->store_result();
        
        return $stmt->num_rows > 0;
        
    }
 
}

?>
