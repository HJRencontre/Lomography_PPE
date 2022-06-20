<?php  
    $unControleur->setTable("vuePanier"); 
    $lesProduitsPanier = $unControleur->selectAll();
    if ($lesProduitsPanier != null)
    {
        $prixTotal = $lesProduitsPanier[0]["total"];
    }
    else
    {
        $prixTotal = "0";
        
    }
    require_once("view/view_liste_panier.php"); 
    if (isset($_POST['ValiderLivraison']))
    {
        // var_dump($_POST);
        $tab = array("dateExpedition"=>$_POST['dateExpedition'], 
                        "datePrevu"=>$_POST['datePrevu'], 
                        "serviceLivraison"=>$_POST['serviceLivraison'], 
                        "adresse"=>$_SESSION['adresse'], 
                        "typeLivraison"=>$_POST['typeLivraison']);
                        // var_dump($tab);
        $unControleur->setTable("livraison"); 
        $unControleur->insert($tab);
        echo"<script>alert('Merci pour votre commande !');</script>";
        
    }

    // Faire un bouton pour supprimer UN produit du panier
    if(isset($_GET['action'])and isset($_GET['idproduit']))
    {
        $action = $_GET['action'];
        $idproduit = $_GET['idproduit'];
        switch ($action)
        {
            case "minus" : $unControleur->updateContenir($idproduit, $_SESSION['idpanier'],-1);break;
            case "plus" : $unControleur->updateContenir($idproduit, $_SESSION['idpanier'],+1);break;
            case "sup" : $unControleur->updateContenir($idproduit, $_SESSION['idpanier'],0);break;
        }
        header("Location: index.php?pn=panier");
    }
    
    require_once ("view/view_liste_livraisons.php");
?>