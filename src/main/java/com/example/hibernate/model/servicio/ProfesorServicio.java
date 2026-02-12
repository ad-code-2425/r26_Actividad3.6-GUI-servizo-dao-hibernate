package com.example.hibernate.model.servicio;

import java.util.List;

import com.example.hibernate.model.Profesor;
import com.example.hibernate.model.dao.IProfesorDao;
import com.example.hibernate.model.util.TransactionManager;
import com.example.hibernate.model.util.exceptions.InstanceNotFoundException;

public class ProfesorServicio implements IProfesorServicio {

    private TransactionManager transactionManager;

    private final IProfesorDao profesorDao;

    public ProfesorServicio(TransactionManager transactionManager, IProfesorDao profesorDao) {
        this.transactionManager = transactionManager;
        this.profesorDao = profesorDao;
        
    }

    public void crear(Profesor profesor) {
        this.transactionManager.ejecutar(() -> {

            profesorDao.create(profesor);
            return null;
        });
    }

    public List<Profesor> findAll() {
        return this.transactionManager.ejecutar(() -> profesorDao.findAll());
    }



    public void delete(Integer profeId) throws InstanceNotFoundException {
        this.transactionManager.ejecutar(() -> {
            profesorDao.remove(profeId);
            return null;
        });

    }

    @Override
    public void actualizar(Profesor profe) {
        this.transactionManager.ejecutar(() -> {
            this.profesorDao.update(profe);
            return null;
        });
    }

}
