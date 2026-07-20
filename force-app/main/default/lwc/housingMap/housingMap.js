import { LightningElement, wire, track } from 'lwc';
import getAccountsWithLocation from '@salesforce/apex/AccountService.getAccountsWithLocation';

export default class HousingMap extends LightningElement {
    @track mapMarkers = [];
    @track error;

    @wire(getAccountsWithLocation)
    wiredAccounts({ error, data }) {
        if (data) {
            this.mapMarkers = data.map(acc => {
                let location = {};

                if (acc.BillingLatitude && acc.BillingLongitude) {
                    location = {
                        Latitude: acc.BillingLatitude,
                        Longitude: acc.BillingLongitude
                    };
                } else {
                    // fallback: use postal code for geocoding later
                    location = {
                        City: acc.BillingCity,
                        State: acc.BillingState,
                        PostalCode: acc.BillingPostalCode
                    };
                }

                return {
                    location,
                    title: acc.Name,
                    description: `${acc.BillingCity}, ${acc.BillingState}`
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.mapMarkers = undefined;
        }
    }
}
