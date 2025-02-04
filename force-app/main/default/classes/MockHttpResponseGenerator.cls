/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 08-11-2022
 * @last modified by  : Aaliyah Mohungoo
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   08-11-2022   Aaliyah Mohungoo   Initial Version
**/

@isTest
global with sharing class MockHttpResponseGenerator implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
        // System.assertEquals('',req.getEndpoint());
        // System.assertEquals('GET', req.getMethod());

        //create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        return res;
    }
}