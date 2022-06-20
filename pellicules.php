<?php
	$unControleur->setTable("viewPellicule"); 
	if (isset($_POST['Rechercher']))
	{
		$tab = array("idproduit","img", "nom", "quantite", "prix", "typeFilm", "developpement", "sensibilite", "format"); 
		$mot = $_POST['mot']; 
		$lesPellicules = $unControleur->selectSearch($tab, $mot); 
	}
	else
	{
		$lesPellicules = $unControleur->selectAll();
	}

	if (isset($_POST['AjouterAuPanier']))
	{
		$idProduit = $_POST['idproduit']; 
		// var_dump($_SESSION);
		// echo "Id produit".$idProduit;
		if (isset($_SESSION['idpanier']))
		{
			//appeler une mise à jour de la quantite dans contenir ou creer une quantite dans contenir si le produit est commandé pour la premiere fois. 
			$unControleur->updateContenir($idProduit, $_SESSION['idpanier'], "+1");
		}else
		{
		$tab = array("idproduit"=>$idProduit);
		$unControleur->insertProc("insertPanier", $tab); 
		$where = array("idproduit"=>$idProduit); 
		$unControleur->setTable("contenir"); 
		$idpanier = $unControleur->selectWhere ($where)["idpanier"];
		//recuperer l'id du panier et le mettre dans la session 
		$_SESSION['idpanier'] =  $idpanier; 
		}
	}
	require_once ("view/view_liste_pellicules.php"); 
?>