import { LightningElement, api, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/AccountOpportunitiesController.getOpportunities';

// Configuration des colonnes avec formatage spécifique pour chaque type de donnée
/* AVANT:
const COLUMNS = [
    { 
        label: 'Nom Opportunité',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    { 
        label: 'Montant',
        fieldName: 'Amount',
        type: 'currency',
        sortable: true,
        typeAttributes: { 
            currencyCode: 'EUR',
            minimumFractionDigits: 2
        }
    }
];
*/

// APRÈS: Ajout du formatage spécifique et amélioration des colonnes
const COLUMNS = [
    { 
        label: 'Nom', 
        fieldName: 'Name', 
        type: 'text',
        sortable: true // Permet le tri sur cette colonne
    },
    { 
        label: 'Montant', 
        fieldName: 'Amount', 
        type: 'currency',
        typeAttributes: { 
            currencyCode: 'EUR', // Format monétaire en euros
            step: '0.01' // Précision à 2 décimales (remplace minimumFractionDigits)
        },
        sortable: true
    },
    {
        label: 'Date de clôture',
        fieldName: 'CloseDate',
        type: 'date',
        typeAttributes: {
            year: 'numeric',
            month: 'long',
            day: '2-digit'
        },
        sortable: true
    },
    {
        label: 'Phase',
        fieldName: 'StageName',
        type: 'text',
        sortable: true
    }
];

export default class AccountOpportunitiesViewer extends LightningElement {
    /* AVANT:
    @api accountId;
    @track opportunities;
    columns = COLUMNS;
    */

    // APRÈS: Ajout de la gestion d'erreurs et utilisation de recordId
    @api recordId;           // Changé de accountId à recordId pour la compatibilité Lightning
    @track opportunities;    // Liste des opportunités avec suivi réactif
    @track error;           // Nouveau: Ajout du suivi des erreurs
    columns = COLUMNS;      // Configuration des colonnes pour le datatable
    
    /* AVANT:
    @wire(getOpportunities, { accountId: '$accountId' })
    wiredOpportunities({ data }) {
        if (data) {
            this.opportunities = data;
        }
    }
    */

    // APRÈS: Amélioration de la gestion des données et des erreurs
    @wire(getOpportunities, { accountId: '$recordId' })
    wiredOpportunities({ error, data }) {
        if (data) {
            // Ajout du formatage des données
            this.opportunities = this.formatOpportunities(data);
            this.error = undefined;
        } else if (error) {
            // Nouveau: Gestion explicite des erreurs
            this.error = 'Une erreur est survenue lors du chargement des opportunités : ' +
                        (error.body?.message || error.message || 'Erreur inconnue');
            this.opportunities = undefined;
        }
    }

    // APRÈS: Nouveaux getters pour l'affichage conditionnel
    get hasOpportunities() {
        return this.opportunities && this.opportunities.length > 0;
    }

    get opportunitiesCount() {
        return this.opportunities ? this.opportunities.length : 0;
    }

    /* AVANT:
    formatOpportunities(opps) {
        return opps.map(opp => ({
            ...opp,
            CloseDate: new Date(opp.CloseDate)
        }));
    }
    */

    // APRÈS: Amélioration du formatage des dates avec localisation
    formatOpportunities(opps) {
        return opps.map(opp => ({
            ...opp,
            CloseDate: new Date(opp.CloseDate).toLocaleDateString('fr-FR', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            })
        }));
    }

    // APRÈS: Nouveau gestionnaire de tri
    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.opportunities];
        
        cloneData.sort((a, b) => {
            return sortDirection === 'asc' ? 
                (a[sortedBy] > b[sortedBy] ? 1 : -1) : 
                (b[sortedBy] > a[sortedBy] ? 1 : -1);
        });
        
        this.opportunities = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
}