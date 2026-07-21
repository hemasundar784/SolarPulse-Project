trigger AccountGeoTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        // Only if coordinates are missing
        if ((acc.Coordinates__Latitude__s == null || acc.Coordinates__Longitude__s == null) 
            && acc.BillingStreet != null) {

            String village = acc.BillingStreet.trim().toLowerCase();

            switch on village {
                when 'bhogapuram' {
                    acc.BillingLatitude       = 18.0311;
                    acc.BillingLongitude      = 83.4967;
                    acc.BillingPostalCode     = '535216';
                    acc.Coordinates__Latitude__s  = 18.0311;
                    acc.Coordinates__Longitude__s = 83.4967;
                }
                when 'visakhapatnam' {
                    acc.BillingLatitude       = 17.6868;
                    acc.BillingLongitude      = 83.2185;
                    acc.BillingPostalCode     = '530001';
                    acc.Coordinates__Latitude__s  = 17.6868;
                    acc.Coordinates__Longitude__s = 83.2185;
                }
                when 'vizianagaram' {
                    acc.BillingLatitude       = 18.1112;
                    acc.BillingLongitude      = 83.3974;
                    acc.BillingPostalCode     = '535001';
                    acc.Coordinates__Latitude__s  = 18.1112;
                    acc.Coordinates__Longitude__s = 83.3974;
                }
                when 'hyderabad' {
                    acc.BillingLatitude       = 17.3850;
                    acc.BillingLongitude      = 78.4867;
                    acc.BillingPostalCode     = '500001';
                    acc.Coordinates__Latitude__s  = 17.3850;
                    acc.Coordinates__Longitude__s = 78.4867;
                }
                // Add more villages/cities as needed
            }
        }
    }
}
