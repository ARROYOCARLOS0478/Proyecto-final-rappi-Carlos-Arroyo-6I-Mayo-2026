import { useNavigate } from "react-router";
import { Mail, Phone } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame"; 

export default function LoginPrincipal() {
  const navigate = useNavigate();

  return (
    <IPhoneFrame>
      {/* Usamos flex-col e h-full para controlar el espacio vertical */}
      <div className="flex flex-col h-full px-6 py-12" style={{ backgroundColor: 'var(--rappi-orange)' }}>
        
        {/* Sección Superior: Logo - Con flex-1 para empujar lo demás hacia abajo */}
        <div className="flex-1 flex flex-col items-center justify-center mt-10">
          <div className="mb-6 animate-bounce-slow">
            {/* Contenedor blanco para el logo */}
            <div className="w-28 h-28 bg-white rounded-[2.5rem] flex items-center justify-center shadow-2xl overflow-hidden p-4">
              <img 
                src="http://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/logo-rappi.png" 
                alt="Rappi Logo"
                className="w-full h-full object-contain"
              />
            </div>
          </div>
          
          <h1 className="text-white text-4xl font-black mb-2 tracking-tighter text-center">
            Bienvenido
          </h1>
          <p className="text-white/90 text-center px-4 font-medium">
            Inicia sesión o regístrate para continuar
          </p>
        </div>

        {/* Sección de Botones: Ahora están más abajo y más redondeados */}
        <div className="w-full space-y-4 mb-8">
          
          {/* Botón Google - Redondeo 3xl */}
          <button
            onClick={() => navigate('/selector-cuentas')}
            className="w-full py-4 px-6 rounded-4xl flex items-center justify-center gap-3 transition-transform active:scale-95 shadow-lg"
            style={{ backgroundColor: 'var(--rappi-google-blue)' }}
          >
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
              <path d="M19.6 10.227c0-.709-.064-1.39-.182-2.045H10v3.868h5.382a4.6 4.6 0 01-1.996 3.018v2.51h3.232c1.891-1.742 2.982-4.305 2.982-7.35z" fill="#ffffff"/>
              <path d="M10 20c2.7 0 4.964-.895 6.618-2.423l-3.232-2.509c-.895.6-2.04.955-3.386.955-2.605 0-4.81-1.76-5.595-4.123H1.064v2.59A9.996 9.996 0 0010 20z" fill="#ffffff"/>
              <path d="M4.405 11.9c-.2-.6-.314-1.24-.314-1.9 0-.66.114-1.3.314-1.9V5.51H1.064A9.996 9.996 0 000 10c0 1.614.386 3.141 1.064 4.49l3.34-2.59z" fill="#ffffff"/>
              <path d="M10 3.977c1.468 0 2.786.505 3.823 1.496l2.868-2.868C14.959.99 12.695 0 10 0 6.09 0 2.71 2.24 1.064 5.51l3.34 2.59C5.19 5.737 7.395 3.977 10 3.977z" fill="#ffffff"/>
            </svg>
            <span className="text-white font-bold text-lg">Continuar con Google</span>
          </button>

          {/* Botón Celular */}
          <button
            onClick={() => navigate('/login-google')}
            className="w-full py-4 px-6 rounded-4xl flex items-center justify-center gap-3 transition-transform active:scale-95 shadow-lg"
            style={{ backgroundColor: 'var(--rappi-turquoise)' }}
          >
            <Phone className="w-5 h-5 text-white" />
            <span className="text-white font-bold text-lg">Continuar con Celular</span>
          </button>

          {/* Botón Correo */}
          <button
            onClick={() => navigate('/login-google')}
            className="w-full py-4 px-6 rounded-4xl flex items-center justify-center gap-3 border-2 border-white/30 bg-white/10 backdrop-blur-sm transition-transform active:scale-95"
          >
            <Mail className="w-5 h-5 text-white" />
            <span className="text-white font-bold text-lg">Continuar con Correo</span>
          </button>
        </div>


      </div>
    </IPhoneFrame>
  );
}