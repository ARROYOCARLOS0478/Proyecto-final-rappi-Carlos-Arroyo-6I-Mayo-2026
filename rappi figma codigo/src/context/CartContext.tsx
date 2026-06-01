import React, { createContext, useContext, useState } from 'react';

const CartContext = createContext<any>(null);

export function CartProvider({ children }: { children: React.ReactNode }) {
  const [items, setItems] = useState<any[]>([]);
  const [tiendaActualId, setTiendaActualId] = useState<string | null>(null);
  const [nombreTienda, setNombreTienda] = useState<string | null>(null);

  const agregarAlCarrito = (producto: any, tiendaId: string, tiendaNombre: string) => {
    // 1. REGLA DE UN SOLO NEGOCIO:
    if (tiendaActualId && tiendaActualId !== tiendaId && items.length > 0) {
      const confirmar = window.confirm(
        `Ya tienes productos de otra tienda en tu canasta. ¿Deseas vaciarla para agregar productos de ${tiendaNombre}?`
      );
      
      if (confirmar) {
        setItems([{ ...producto, cantidad: Math.max(1, producto.cantidad) }]);
        setTiendaActualId(tiendaId);
        setNombreTienda(tiendaNombre);
      }
      return;
    }

    // Si la canasta estaba vacía, seteamos la nueva tienda
    if (items.length === 0) {
      setTiendaActualId(tiendaId);
      setNombreTienda(tiendaNombre);
    }

    setItems((prev) => {
      const existe = prev.find((item) => item.id === producto.id);
      
      if (existe) {
        const nuevaCantidad = existe.cantidad + producto.cantidad;

        // 2. REGLA DE NO NEGATIVOS: Si la cantidad llega a 0 o menos, lo eliminamos
        if (nuevaCantidad <= 0) {
          const nuevosItems = prev.filter((item) => item.id !== producto.id);
          // 3. SI ERA EL ÚLTIMO PRODUCTO: Limpiamos los datos de la tienda
          if (nuevosItems.length === 0) {
            setTiendaActualId(null);
            setNombreTienda(null);
          }
          return nuevosItems;
        }

        // Si no es cero, actualizamos la cantidad normal
        return prev.map((item) =>
          item.id === producto.id 
            ? { ...item, cantidad: nuevaCantidad } 
            : item
        );
      }
      
      // Si el producto es nuevo y la cantidad es positiva, lo agregamos
      return producto.cantidad > 0 ? [...prev, producto] : prev;
    });
  };

  // Función extra para vaciar todo de golpe si lo necesitas
  const limpiarCarrito = () => {
    setItems([]);
    setTiendaActualId(null);
    setNombreTienda(null);
  };

  const totalProductos = items.reduce((acc, item) => acc + item.cantidad, 0);
  const totalPrecio = items.reduce((acc, item) => acc + (item.precio * item.cantidad), 0);

  return (
    <CartContext.Provider value={{ 
      items, 
      agregarAlCarrito, 
      totalProductos, 
      totalPrecio, 
      tiendaActualId,
      nombreTienda,
      limpiarCarrito 
    }}>
      {children}
    </CartContext.Provider>
  );
}

export const useCart = () => useContext(CartContext);