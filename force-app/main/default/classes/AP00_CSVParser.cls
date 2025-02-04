/**
 * @description       : 
 * @author            : Aaliyah Mohungoo
 * @group             : 
 * @last modified on  : 20-11-2022
 * @last modified by  : Aaliyah Mohungoo 
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   20-11-2022   Aaliyah Mohungoo   Initial Version
**/
public with sharing class AP00_CSVParser {
    Public list <String> header;
    public list<String> line;
    public string body;
    public boolean hasHeader;

    public AP00_CSVParser(){
        header = new list <String>();       
        line = new list<String>();
        body = '';
        hasHeader = false;
    }
    public void writeHeader(list<String> h){       
        if(h.size()>0){
            for(integer i=0;i<h.size();i++){
                header.add(h[i]);
                body += formatData(h[i])+ ',';  
            }
            body = body.removeEnd(',');
            body += '\r\n';
            hasHeader = true;
        }
        else{
            body='';
            hasHeader=false;
        }
    }
    public String formatData(string s){
        if(s!=null) { 
            s = s.replaceAll('"','');          
        }
        else{
            s='';
        }
         return '"' + s + '"';
    }
    public void addToLine(String s){
        line.add(formatData(s));
        body += formatData(s) + ',';    
    }
    public void createLine(){
        body = body.removeEnd(',');
        body += '\r\n';
    }
    public blob getBlobBody(){
        return blob.valueOf(body);
    }
}