declare module "@salesforce/apex/CourierTrackingSystemController.getAccountDetails" {
  export default function getAccountDetails(param: {accId: any}): Promise<any>;
}
declare module "@salesforce/apex/CourierTrackingSystemController.createOrUpdateTracking" {
  export default function createOrUpdateTracking(param: {trackingId: any, accId: any, scheduledDate: any, scheduledTime: any}): Promise<any>;
}
declare module "@salesforce/apex/CourierTrackingSystemController.confirmCourierPickup" {
  export default function confirmCourierPickup(param: {trackingId: any, accId: any}): Promise<any>;
}
declare module "@salesforce/apex/CourierTrackingSystemController.setCourierAsDelivered" {
  export default function setCourierAsDelivered(param: {trackingId: any, accId: any, receivedBy: any, receivedByPhone: any}): Promise<any>;
}
declare module "@salesforce/apex/CourierTrackingSystemController.getCourierStatus" {
  export default function getCourierStatus(param: {trackingId: any}): Promise<any>;
}
declare module "@salesforce/apex/CourierTrackingSystemController.callCourierService" {
  export default function callCourierService(param: {trackingId: any, accId: any}): Promise<any>;
}
