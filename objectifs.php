<?php
	$unControleur->setTable("viewObjectif"); 
	if (isset($_POST['Rechercher']))
	{
		$tab = array("idproduit", "img", "nom", "quantite", "prix", "poids", "diametreMaxAndLongueur", "moteurAutoFocus", "agrandissement"); 
		$mot = $_POST['mot']; 
		$lesObjectifs = $unControleur->selectSearch($tab, $mot); 
	}
	else
	{
		$lesObjectifs = $unControleur->selectAll();
	}

	if (isset($_POST['AjouterAuPanier']))
	{
		$idProduit = $_POST['idproduit']; 
		 
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
	require_once ("view/view_liste_objectifs.php"); 
?>