<?php  
    $unControleur->setTable("vuePanier"); 
    $lesProduitsPanier = $unControleur->selectAll();
    $prixTotal = $lesProduitsPanier[0]["total"];
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
    
    // Faire un bouton pour vider le panier
     
    require_once ("view/view_liste_livraisons.php");
?>