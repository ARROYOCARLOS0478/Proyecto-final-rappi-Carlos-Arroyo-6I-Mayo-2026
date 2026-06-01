import { createBrowserRouter } from "react-router";

// Importaciones de tus páginas existentes
import LoginPrincipal from "./pages/LoginPrincipal";
import SelectorCuentas from "./pages/SelectorCuentas";
import LoginGoogle from "./pages/LoginGoogle";
import SetupDireccion from "./pages/SetupDireccion";
import HomeDashboard from "./pages/HomeDashboard";
import Direcciones from "./pages/Direcciones";
import Canasta from "./pages/canasta";
import Pago from "./pages/Pago";
import ProPedi from "./pages/ProcesandoPedido";
import DetaEntre from "./pages/detalleentrega";
import Ofertas from "./pages/Ofertas";
import Favoritos from "./pages/Favoritos"
import Cuenta from "./pages/Cuenta";

// PÁGINAS DINÁMICAS
import SeccionGeneral from "./pages/SeccionGeneral";
import TiendaDetalle from "./pages/TiendaDetalle";
import ProductoDetalle from "./pages/ProductoDetalle";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: LoginPrincipal,
  },
  {
    path: "/selector-cuentas",
    Component: SelectorCuentas,
  },
  {
    path: "/login-google",
    Component: LoginGoogle,
  },
  {
    path: "/setup-direccion",
    Component: SetupDireccion,
  },
  {
    path: "/direcciones",
    Component: Direcciones,
  },
  {
    path: "/home",
    Component: HomeDashboard,
  },
  
  // --- MOTOR GLOBAL DE CATEGORÍAS ---
  {
    path: "/seccion/:categoriaId",
    Component: SeccionGeneral,
  },
  {
    // Agregamos :categoriaId para que la tienda sepa de dónde viene
    path: "/tienda/:categoriaId/:tiendaId",
    Component: TiendaDetalle,
  },
  {
    // Ruta completa para el producto: categoría -> tienda -> producto
    path: "/producto/:categoriaId/:tiendaId/:prodId",
    Component: ProductoDetalle,
  },
  // ----------------------------------------------

  {
    path: "/canasta",
    Component: Canasta,
  },
  {
    path: "/Pago",
    Component: Pago,
  },
  {
    path: "/Pro-pedi",
    Component: ProPedi,
  },
  {
    path: "/Deta-entre",
    Component: DetaEntre,
  },
  {
    path: "/ofertas",
    Component: Ofertas,
  },
  {
    path: "/favoritos",
    Component: Favoritos,
  },
  {
    path: "/cuenta",
    Component: Cuenta,
  },
]);