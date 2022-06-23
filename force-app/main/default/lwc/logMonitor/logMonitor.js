import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
const columns = [
    { label: 'Exception Message', fieldName: 'Exception_Message__c' },
    { label: 'Method Name', fieldName: 'Method_Name__c' },
    { label: 'CreatedDate', fieldName: 'CreatedDate' },
    { label: 'Exception Type', fieldName: 'Exception_Type__c' },
    { label: 'Class Name', fieldName: 'Class_Name__c' }
];

export default class LogMonitor extends LightningElement {
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;
    subscription = {};
    @track logs=[];
    columns = columns;
    channelName='/event/Exception_Log_Platform_Event__e';
    @track tempid=1;
    @track logdata=[];

    tableValue=[];
    clearAll() {
        this.logdata = [];
        this.logs=[];
        console.log('Clear Logs'+this.logs.length);
    }

   
    handleSubscribe(){
        subscribe(this.channelName,-1,this.messageCallback).then(response =>{
            this.subscription=response;
            this.toggleButton(true);
        });
    }

     connectedCallback() {
        for(let col of columns){
            let colval=Object.values(col);
            console.log('Colval'+JSON.stringify(colval));
            this.tableValue.push(colval[1]);
        }
        console.log('tableValue>>'+this.tableValue);
        this.handleSubscribe();
    }

    messageCallback = (response) =>{
        this.logdata=[];
        let item=response.data.payload;
        item.id=this.tempid;
        this.logs.push(response.data.payload);
        this.logs.forEach(log => {
            this.logdata.push(log);
        });
        //this.logdata=this.logs;
        console.log(this.logdata.length);
        console.log('logs>>>>'+JSON.stringify(this.logs));
        console.log('LOGDATA>>>>'+JSON.stringify(this.logdata));
        this.tempid++;
        
    }

    handleSearch(event){

        const searchKey = event.target.value.toLowerCase();
        if(searchKey) {
            this.logdata = this.logs;
            if(this.logdata){
                let recs = [];
                for(let rec of this.logdata){
                    console.log('REC'+JSON.stringify(rec));
                    let keyArray = Object.keys(rec);
                    for(let key of keyArray){
                        if(this.tableValue.includes(key)){
                            let val=rec[key];
                            console.log('VAL'+val);
                            let strVal = String(val);
                            if(strVal){
                                if(strVal.toLowerCase().includes(searchKey)){
                                    recs.push(rec);
                                    break;
                                }
                            }
                        }
                    }                   
                }
                this.logdata = recs;
            }
        }  
        else {
            this.logdata = this.logs;
        }        
    }

    handleUnsubscribe() {
        this.toggleButton(false);
        unsubscribe(this.subscription, (response) => {});
    }

    toggleButton(enableSubscribe) {
        this.isSubscribeDisabled = enableSubscribe;
        this.isUnsubscribeDisabled = !enableSubscribe;
    }
}