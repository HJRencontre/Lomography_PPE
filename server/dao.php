

<?php
class DAO {

    public function __construct($bdd, $resource) {
        $this->conn = $bdd;
        $this->resource= $resource;
    }

    public function get($id=null){
		$whereID = " where id=";
		if($this->resource=="appareil" 
		or $this->resource=="pellicule"
		or $this->resource=="objectif"
		or $this->resource=="produit"){
			$whereID= " where idproduit=";
		}
		if($this->resource=="user"){
			$whereID = " where iduser=";
		}
		if($this->resource=="livraison"){
			$whereID = " where idlivraison=";
		}
		if($this->resource=="contenir"){
			$whereID = " where idpanier =";
		}
		

        $query = "SELECT * FROM ".$this->resource. ($id ? $whereID.$id : "");

		if($this->resource=="livraison"){
			$query = "SELECT * FROM  livraison inner join choisir on choisir.idlivraison= livraison.idlivraison ". ($id ? $whereID.$id : "");
		}

		if($this->resource=="livraisondetails"){
			$query= "SELECT produit.idproduit, produit.img, produit.nom, produit.prix, contenir.qte, panier.prix as prixPanier
			from produit 
			LEFT JOIN contenir on contenir.idproduit = produit.idproduit
			LEFT JOIN panier on contenir.idpanier = panier.idpanier
			LEFT JOIN choisir on choisir.idpanier = panier.idpanier
			LEFT JOIN livraison on choisir.idlivraison = livraison.idlivraison
			WHERE livraison.idlivraison=$id;";
			//var_dump($query);
		}
        $response = array();
        $result = mysqli_query($this->conn, $query);
        while($row = mysqli_fetch_array($result, MYSQLI_ASSOC))
		{
            $row = array_map(function($value){
                if(is_string($value))return utf8_encode($value);
                else return $value;
            },$row);
            $response[] = $row;
        }
		if($this->resource!="livraisondetails"){
			$response = ($id ? $response[0] : $response); 
		}
        header('Content-Type: application/json');
		echo json_encode($response, JSON_PRETTY_PRINT);
    }


    public function add(){
        $query="INSERT INTO ".$this->resource."(".implode(",", array_keys($_POST)).") ";
        $query.= " VALUES(";
        foreach($_POST as $value){
            $query.= "'".$value."', ";
        }
        $query= substr($query, 0, -2).")";
        if(mysqli_query($this->conn, $query))
		{
			$response=array(
				'status' => 1,
				'status_message' =>'Ressource ajouté avec succés.'
			);
		}
		else
		{
			$response=array(
				'status' => 0,
				'status_message' =>'ERREUR!.'. mysqli_error($this->conn)
			);
		}
		header('Content-Type: application/json');
		echo json_encode($response);
    }

	public function connection()
	{
		$email = $_POST['email'];
		$mdp = $_POST['mdp'];
		$query="select iduser, email, mdp from user where email='".$email."' and mdp='".$mdp."';";
		$result = mysqli_query($this->conn, $query);
		$data = mysqli_fetch_array($result, MYSQLI_ASSOC);
		if($data)
		{
			$response=array(
				'status' => 200,
				'userid' => $data["iduser"],
				'status_message' =>'Connecté avec succès.'
			);
		}else{
			$response=array(
				'status' => 403,
				'status_message' =>'No authorized.'
			);
		}
		header('Content-Type: application/json');
		echo json_encode($response);
	}

    public function update($id){
		$whereID = " where id=";
		if($this->resource=="appareil" 
		or $this->resource=="pellicule"
		or $this->resource=="objectif"
		or $this->resource=="produit"){
			$whereID= " where idproduit=";
		}
		if($this->resource=="user"){
			$whereID = " where iduser=";
		}
		if($this->resource=="livraison"){
			$whereID = " where idlivraison=";
		}
		if($this->resource=="contenir"){
			$whereID = " where idpanier=";
		}


        $_PUT = array();
		parse_str(file_get_contents('php://input'), $_PUT);
        $query="UPDATE ".$this->resource." SET ";
        foreach($_PUT as $key=>$value){
            $query.= $key."='".$value."', ";
        }
        $query= substr($query, 0, -2).$whereID.$id;
        if(mysqli_query($this->conn, $query))
		{
			$response=array(
				'status' => 1,
				'status_message' =>'Ressource mis a jour avec succes.'
			);
		}
		else
		{
			$response=array(
				'status' => 0,
				'status_message' =>'Echec de la mise a jour de la ressource. '. mysqli_error($this->conn)
			);
			
		}
		header('Content-Type: application/json');
		echo json_encode($response);
    }

    public function delete($id){
		$whereID = " where id=";
		if($this->resource=="appareil" 
		or $this->resource=="pellicule"
		or $this->resource=="objectif"
		or $this->resource=="produit"){
			$whereID= " where idproduit=";
		}
		if($this->resource=="user"){
			$whereID = " where iduser=";
		}
		if($this->resource=="livraison"){
			$whereID = " where idlivraison=";
		}
		if($this->resource=="contenir"){
			$whereID = " where idpanier=";
		}

		// $query = "DELETE FROM ".$this->resource." WHERE id=".$id;
		// DELETE FROM table where idTABLE = id;
        $query = "DELETE FROM ".$this->resource.$whereID.$id;
		if(mysqli_query($this->conn, $query))
		{
			$response=array(
				'status' => 1,
				'status_message' =>'Ressource supprimé avec succés.'
			);
		}
		else
		{
			$response=array(
				'status' => 0,
				'status_message' =>'La suppression de la ressource a échoué.'. mysqli_error($this->conn)
			);
		}
		header('Content-Type: application/json');
		echo json_encode($response);
    }
}
?>