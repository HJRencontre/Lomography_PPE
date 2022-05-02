<form method='post' action=''>
    <table class="styled-table">
        <tr id="ligneTab">
            <td>Type de livraison</td>
            <td>Service de livraison</td>
            <td> Prix total à payer </td>
            <td> Date Prévue </td>
            <td>Opération</td>
        </tr>
        <tr>
            <td>
                <select name="typeLivraison" id="typeLivraison">
                    <option value="Point relais">Point relais</option>
                    <option value="A domicile">A domicile</option>
                </select>
            </td>
            <td>
                <select name="serviceLivraison" id="">
                    <option value="DPD">DPD</option>
                    <option value="Chronopost">Chronopost</option>
                    <option value="Mondial Relay">Mondial Relay</option>
                </select>
            </td>
            <td>
                <input type ="text" name ="prixTotal" value ="<?= $prixTotal ?>€" readonly="true"  >
            </td>
<?php
     $dateExpedition = date('Y-m-d');
    $datePrevu = date('Y-m-d', strtotime('+10 days'));
?>
            <td>
                <input type ="text" name ="datePrevu" value ="<?= $datePrevu ?>" readonly="true">
                <input type ="hidden" name ="dateExpedition" value ="<?= $dateExpedition ?>" >
            </td>

            <td>
                <input type='submit' value='Valider' name='ValiderLivraison'>
            </td>
        </tr>
    </table>
</form>