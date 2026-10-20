using System;

namespace EcommerceOrderSystem
{
    [Serializable]
    public class CartItem
    {
        public long ProductId { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public int Stock { get; set; }

        public decimal SubTotal
        {
            get { return Price * Quantity; }
        }
    }
}