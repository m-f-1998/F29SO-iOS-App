<?php

class dbOperation {

    private $conn;

    function __construct () {

        require_once $_SERVER['DOCUMENT_ROOT'].'/pedalPay/dbConnection/constants.php';
        require_once $_SERVER['DOCUMENT_ROOT'].'/pedalPay/dbConnection/dbConnect.php';

        $db = new DbConnect ();
        $this->conn = $db->connect ();

    }

    public function userDetails () {

        $stmt = $this->conn->query("SELECT id, email FROM users;");
        
        $res = array();
        while ($data = $stmt->fetch_assoc()) {
            
            array_push($res, $data);
            
        }
        return $res;

    }

    public function userBookings ($pid) {

        $stmt = $this->conn->prepare("SELECT * FROM booking WHERE pid = ?;");
        $stmt->bind_param ("s", $pid);
        $stmt->execute ();
        $result = $stmt->get_result();
        
        $res = array();
        while ($data = $result->fetch_array()) {
            
            array_push($res, $data);
            
        }
        return $res;

    }

    public function bikeUpdates ($bid) {

        $stmt = $this->conn->prepare("SELECT * FROM `bikeupdates` WHERE `bookid` = ?;");
        $stmt->bind_param ("s", $bid);
        $stmt->execute ();
        $result = $stmt->get_result();
        
        $res = array();
        while ($data = $result->fetch_array()) {
            
            array_push($res, $data);
            
        }
        return $res;

    }
    
}

?>
