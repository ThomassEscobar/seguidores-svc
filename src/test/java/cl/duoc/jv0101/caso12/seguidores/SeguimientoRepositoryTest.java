package cl.duoc.jv0101.caso12.seguidores;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import cl.duoc.jv0101.caso12.seguidores.model.Seguimiento;
import cl.duoc.jv0101.caso12.seguidores.repository.SeguimientoRepository;

@DataJpaTest 
public class SeguimientoRepositoryTest {

     @Autowired
    private SeguimientoRepository repository;

    @Test
    void saveYFindById_funciona() {
        Seguimiento s = new Seguimiento();
        s.setNombre("Repo Test");
        s.setSeguidor("a");
        s.setSeguido("b");

        Seguimiento guardado = repository.save(s);

        assertThat(guardado.getId()).isNotNull();
        Optional<Seguimiento> encontrado = repository.findById(guardado.getId());
        assertThat(encontrado).isPresent();
        assertThat(encontrado.get().getNombre()).isEqualTo("Repo Test");
    
}

 @Test
    void findAll_retornaTodos() {
        Seguimiento s1 = new Seguimiento();
        s1.setNombre("Uno");
        Seguimiento s2 = new Seguimiento();
        s2.setNombre("Dos");
        repository.saveAll(List.of(s1, s2));

        assertThat(repository.findAll()).hasSize(2);
    }

    @Test
    void delete_eliminaEntidad() {
        Seguimiento s = new Seguimiento();
        s.setNombre("Borrar");
        Seguimiento guardado = repository.save(s);

        repository.delete(guardado);

        assertThat(repository.findById(guardado.getId())).isEmpty();
    }
}
