import { Box, Container } from "@chakra-ui/react";
import { PropsWithChildren } from "react";
import Header from "src/components/Header";

function Layout({ children }: PropsWithChildren<{}>) {
  return (
    <Container as="main" maxW={1024} minHeight="100dvh" bgColor="red.100">
      <Header />
      {children}
    </Container>
  );
}

export default Layout;
