// Importation des modules nécessaires pour le composant Lightning
import { LightningElement, api, track } from 'lwc';
import findCasesBySubject from '@salesforce/apex/AccountCasesController.findCasesBySubject';

/**
 * Configuration des colonnes pour le tableau de données
 * Définit la structure et le formatage de chaque colonne
 */
const COLUMNS = [
    { 
        label: 'Sujet',
        fieldName: 'Subject',
        type: 'text',
        sortable: true,
        wrapText: true
    },
    { 
        label: 'Statut',
        fieldName: 'Status',
        type: 'text',
        sortable: true
    },
    { 
        label: 'Priorité',
        fieldName: 'Priority',
        type: 'text',
        sortable: true
    },
    {
        label: 'Date de création',
        fieldName: 'CreatedDate',
        type: 'date',
        sortable: true,
        typeAttributes: {
            year: 'numeric',
            month: 'long',
            day: '2-digit'
        }
    }
];

/**
 * Composant de recherche de cas
 * Permet de rechercher et d'afficher les cas liés à un compte
 */
export default class AccountCasesSearcher extends LightningElement {
    // Propriétés du composant
    @api recordId;
    @track cases;
    @track error;
    @track isLoading = false;
    searchTerm = '';
    columns = COLUMNS;

    /**
     * Gestionnaire d'événement pour la mise à jour du terme de recherche
     * @param {Event} event - Événement de changement du champ de recherche
     */
    updateSearchTerm(event) {
        this.searchTerm = event.target.value;
        if (this.searchTerm === '') {
            this.cases = undefined;
            this.error = undefined;
        }
    }

    /**
     * Effectue la recherche des cas
     * Gère les erreurs et formate les résultats
     */
    handleSearch() {
        if (!this.searchTerm) {
            this.error = 'Veuillez entrer un terme de recherche';
            return;
        }

        this.isLoading = true;
        this.cases = undefined;
        this.error = undefined;

        findCasesBySubject({ 
            accountId: this.recordId,
            subjectSearchTerm: this.searchTerm 
        })
            .then(result => {
                this.cases = this.formatCases(result);
                if (this.cases.length === 0) {
                    this.error = 'Aucun cas trouvé pour ce terme de recherche';
                }
            })
            .catch(error => {
                this.error = 'Une erreur est survenue lors de la recherche des cas : ' + 
                            (error.body?.message || error.message || 'Erreur inconnue');
                console.error('Error in handleSearch:', error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    /**
     * Formate les cas pour l'affichage
     * @param {Array} cases - Liste des cas à formater
     * @return {Array} Liste des cas formatés
     */
    formatCases(cases) {
        return cases.map(caseItem => ({
            ...caseItem,
            CreatedDate: new Date(caseItem.CreatedDate)
        }));
    }

    /**
     * Retourne le nombre de cas trouvés
     * @return {Number} Nombre de cas
     */
    get resultCount() {
        return this.cases ? this.cases.length : 0;
    }
}