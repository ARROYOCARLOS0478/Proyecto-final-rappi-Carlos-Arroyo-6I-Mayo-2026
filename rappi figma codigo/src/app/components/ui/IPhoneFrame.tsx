import { ReactNode } from "react";

interface IPhoneFrameProps {
  children: ReactNode;
}

export function IPhoneFrame({ children }: IPhoneFrameProps) {
  return (
    <div className="min-h-screen bg-gray-900 flex items-center justify-center p-4">
      <div className="relative bg-black rounded-[3rem] p-3 shadow-2xl" style={{ width: '390px', height: '844px' }}>
        {/* Notch */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-40 h-7 bg-black rounded-b-3xl z-50"></div>
        
        {/* Screen */}
        <div className="relative w-full h-full bg-white rounded-[2.5rem] overflow-hidden">
          {/* Status Bar */}
          <div className="absolute top-0 left-0 right-0 h-11 bg-transparent z-40 flex items-start justify-between px-8 pt-2 text-xs">
            <div className="text-black">9:41</div>
            <div className="flex items-center gap-1">
              <svg className="w-4 h-4" viewBox="0 0 24 24" fill="none">
                <path d="M2 12.88V11.12C2 10.08 2.85 9.23 3.9 9.23C5.71 9.23 6.45 7.94 5.54 6.37C5.02 5.47 5.33 4.3 6.24 3.78L7.97 2.79C8.76 2.32 9.78 2.6 10.25 3.39L10.36 3.58C11.26 5.15 12.74 5.15 13.65 3.58L13.76 3.39C14.23 2.6 15.25 2.32 16.04 2.79L17.77 3.78C18.68 4.3 18.99 5.47 18.47 6.37C17.56 7.94 18.3 9.23 20.11 9.23C21.15 9.23 22.01 10.08 22.01 11.12V12.88C22.01 13.92 21.16 14.77 20.11 14.77C18.3 14.77 17.56 16.06 18.47 17.63C18.99 18.54 18.68 19.7 17.77 20.22L16.04 21.21C15.25 21.68 14.23 21.4 13.76 20.61L13.65 20.42C12.75 18.85 11.27 18.85 10.36 20.42L10.25 20.61C9.78 21.4 8.76 21.68 7.97 21.21L6.24 20.22C5.33 19.7 5.02 18.53 5.54 17.63C6.45 16.06 5.71 14.77 3.9 14.77C2.85 14.77 2 13.92 2 12.88Z" stroke="currentColor" strokeWidth="1.5" strokeMiterlimit="10" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
              <svg className="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
                <rect x="2" y="7" width="5" height="11" rx="1"/>
                <rect x="9" y="5" width="5" height="13" rx="1"/>
                <rect x="16" y="3" width="5" height="15" rx="1"/>
              </svg>
              <svg className="w-6 h-3" viewBox="0 0 24 12" fill="none">
                <rect x="1" y="1" width="18" height="10" rx="2" stroke="currentColor" strokeWidth="1"/>
                <path d="M20 4v4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
              </svg>
            </div>
          </div>
          
          {/* App Content */}
          <div className="w-full h-full overflow-y-auto">
            {children}
          </div>
        </div>
        
        {/* Home Indicator */}
        <div className="absolute bottom-2 left-1/2 -translate-x-1/2 w-32 h-1 bg-white rounded-full"></div>
      </div>
    </div>
  );
}
