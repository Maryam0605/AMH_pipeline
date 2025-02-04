/**
 * @description       : 
 * @author            : Sambhav Bholah
 * @group             : 
 * @last modified on  : 11-22-2023
 * @last modified by  : Sambhav Bholah
**/
public with sharing class CookbookBot_GetOrderStatus {

    public class OrderOutput {
      @InvocableVariable(required=true)
      public String sOrderDesc;
    }
  
    public class OrderInput {
      @InvocableVariable(required=true)
      public String sOrderNumber;
    }
  
    @InvocableMethod(label='Get Order Status 01')
    public static List<OrderOutput> getOrderStatus(List<OrderInput> lstOrderInputs) {
      System.debug('>> SBL getOrderStatus starts');
      System.debug('>> SBL lstOrderInputs' + lstOrderInputs);

      Set<String> setOrderNumbers = new Set<String>(); 
  
      // Get the order numbers from the input
      for (OrderInput orderInput : lstOrderInputs) {
        setOrderNumbers.add(orderInput.sOrderNumber);
      }
      
      System.debug('>> SBL setOrderNumbers'  +setOrderNumbers);

      // Get the order objects from the set of order numbers
      List<Order> lstOrders = [SELECT OrderNumber, Description FROM Order Where OrderNumber IN: setOrderNumbers];
      System.debug('>> SBL lstlstOrders' + lstOrders);

        
      // Create a map of order numbers and order status values
      Map<String, String> mapNameToDesc = new Map<String, String>(); 
      if (lstOrders.size() > 0) {
          for (Order order : lstOrders) {
            mapNameToDesc.put(order.OrderNumber, order.Description);
          }
      }
      
      // Build a list of order status values for the output
      List<OrderOutput> lstOrderOutput = new List<OrderOutput>();
      for (OrderInput orderInput : lstOrderInputs) {
        OrderOutput orderOutput = new OrderOutput();
        
        // Do we have a status for this order number?
        if (mapNameToDesc.containsKey(orderInput.sOrderNumber)) {
            // If so, then add the status
            orderOutput.sOrderDesc = 'So product with order number '  + orderInput.sOrderNumber +  ' has the description :' + mapNameToDesc.get(orderInput.sOrderNumber);
        } else {
            // If not, then add an unknown status value
            orderOutput.sOrderDesc = 'So product with order number ' + orderInput.sOrderNumber + ' does not exist.';
        }
        lstOrderOutput.add(orderOutput);
      }
  
      return lstOrderOutput;    
    }
  }