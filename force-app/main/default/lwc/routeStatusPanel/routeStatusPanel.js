import { LightningElement, api, track, wire } from 'lwc';
import getRoutes from '@salesforce/apex/InstallationController.getRoutesByInstallation';
import updateRouteStatus from '@salesforce/apex/InstallationController.updateRouteStatus';
import INSTALLATION_MC from '@salesforce/messageChannel/InstallationUpdateChannel__c';
export default class RouteStatusPanel extends LightningElement {
    @api recordId;          
    @api installationName;  
    @track routes = [];     
    @wire(getRoutes, { installationId: "$recordId" })
    wiredRoutes({ data, error }) {
        if (data)  { this.routes = data; }
        else if (error) { console.error('[RoutePanel] Wire error:', error); }
    }
    async handleDispatch(event) {
        const routeId = event.target.dataset.id;
        try {
            await updateRouteStatus({ routeId, newStatus: 'Dispatched' });
            this.dispatchEvent(new CustomEvent('routeupdated', {
                detail: { routeId, newStatus: 'Dispatched' },
                bubbles: true,
                composed: true
            }));
        } catch (err) {
            console.error('[RoutePanel] Error dispatching route:', err);
        }
    }
}