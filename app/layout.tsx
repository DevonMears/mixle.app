import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Mixle - Intent-Based Event Matching",
  description: "Meet people at events based on what you want to do right now",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
